import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var recipes: [Recipe] = []
    @Published var selectedIngredientIDs: Set<String> = []
    @Published var favoriteRecipeIDs: Set<String> = []
    @Published var searchText = ""
    @Published var selectedRandomMode: RandomMode = .cook
    @Published var randomRecipe: Recipe?
    @Published var randomOrderSuggestion: String?
    @Published var pantryIngredientIDs: Set<String> = []
    @Published var weeklyPlan: [Int: String] = [:]
    @Published var checkedShoppingItems: Set<String> = []

    private let defaults = UserDefaults.standard
    private let usageDateKey = "usage.date"
    private let usageCountKey = "usage.count"
    private let rewardCountKey = "usage.reward"
    private let favoritesKey = "favorites"
    private let pantryKey = "pantry.ingredients"
    private let weeklyPlanKey = "mealPlan.week"
    private let shoppingChecksKey = "shopping.checked"

    enum RandomMode: String, CaseIterable, Identifiable {
        case cook = "Bugün Ne Pişirsem?"
        case order = "Ne Sipariş Etsem?"
        var id: String { rawValue }
    }

    func loadDataIfNeeded() {
        guard ingredients.isEmpty, recipes.isEmpty else { return }
        ingredients = Bundle.main.decode([Ingredient].self, from: "ingredients.json")
        recipes = Bundle.main.decode([Recipe].self, from: "recipes.json")
        favoriteRecipeIDs = Set(defaults.stringArray(forKey: favoritesKey) ?? [])
        pantryIngredientIDs = Set(defaults.stringArray(forKey: pantryKey) ?? [])
        checkedShoppingItems = Set(defaults.stringArray(forKey: shoppingChecksKey) ?? [])
        weeklyPlan = Self.decodePlan(defaults.dictionary(forKey: weeklyPlanKey) ?? [:])
        resetDailyUsageIfNeeded()
    }

    var filteredIngredients: [Ingredient] {
        let query = SearchNormalizer.normalize(searchText)
        if query.isEmpty {
            let selected = ingredients.filter { selectedIngredientIDs.contains($0.id) }
            let remaining = ingredients.filter { !selectedIngredientIDs.contains($0.id) }
            return Array((selected + remaining).prefix(220))
        }

        let queryWords = query.split(separator: " ").map(String.init)
        return ingredients.compactMap { ingredient -> (Ingredient, Int)? in
            let name = SearchNormalizer.normalize(ingredient.name)
            let tokens = ingredient.searchTokens.map(SearchNormalizer.normalize)
            let searchable = ([name] + tokens).joined(separator: " ")

            guard queryWords.allSatisfy(searchable.contains) else { return nil }

            let score: Int
            if name == query {
                score = 0
            } else if name.hasPrefix(query) {
                score = 1
            } else if tokens.contains(query) {
                score = 2
            } else if name.contains(query) {
                score = 3
            } else {
                score = 4
            }
            return (ingredient, score)
        }
        .sorted {
            if $0.1 == $1.1 {
                if $0.0.name.count == $1.0.name.count {
                    return $0.0.name.localizedCaseInsensitiveCompare($1.0.name) == .orderedAscending
                }
                return $0.0.name.count < $1.0.name.count
            }
            return $0.1 < $1.1
        }
        .prefix(250)
        .map(\.0)
    }

    func toggleIngredient(_ ingredient: Ingredient) {
        if selectedIngredientIDs.contains(ingredient.id) {
            selectedIngredientIDs.remove(ingredient.id)
        } else {
            selectedIngredientIDs.insert(ingredient.id)
        }
    }

    func matches(limit: Int = 120) -> [RecipeMatch] {
        guard !selectedIngredientIDs.isEmpty else { return [] }

        return recipes.map { recipe in
            let required = Set(recipe.ingredients.map(\.ingredientID))
            let matched = required.intersection(selectedIngredientIDs).count
            let percentage = required.isEmpty ? 0 : Int((Double(matched) / Double(required.count) * 100).rounded())
            let missing = recipe.ingredients.filter {
                !selectedIngredientIDs.contains($0.ingredientID)
            }
            return RecipeMatch(
                recipe: recipe,
                matchPercentage: percentage,
                missingIngredients: missing
            )
        }
        .filter { $0.matchPercentage > 0 }
        .sorted {
            if $0.matchPercentage == $1.matchPercentage {
                if $0.missingIngredients.count == $1.missingIngredients.count {
                    return $0.recipe.name < $1.recipe.name
                }
                return $0.missingIngredients.count < $1.missingIngredients.count
            }
            return $0.matchPercentage > $1.matchPercentage
        }
        .prefix(limit)
        .map { $0 }
    }

    func toggleFavorite(_ recipe: Recipe) {
        if favoriteRecipeIDs.contains(recipe.id) {
            favoriteRecipeIDs.remove(recipe.id)
        } else {
            favoriteRecipeIDs.insert(recipe.id)
        }
        defaults.set(Array(favoriteRecipeIDs), forKey: favoritesKey)
    }

    func isFavorite(_ recipe: Recipe) -> Bool {
        favoriteRecipeIDs.contains(recipe.id)
    }

    var favoriteRecipes: [Recipe] {
        recipes.filter { favoriteRecipeIDs.contains($0.id) }
    }

    func togglePantryIngredient(_ ingredient: Ingredient) {
        if pantryIngredientIDs.contains(ingredient.id) {
            pantryIngredientIDs.remove(ingredient.id)
        } else {
            pantryIngredientIDs.insert(ingredient.id)
        }
        defaults.set(Array(pantryIngredientIDs), forKey: pantryKey)
    }

    func addToPlan(_ recipe: Recipe, day: Int) {
        weeklyPlan[day] = recipe.id
        savePlan()
    }

    func removeFromPlan(day: Int) {
        weeklyPlan.removeValue(forKey: day)
        savePlan()
    }

    func plannedRecipe(for day: Int) -> Recipe? {
        guard let id = weeklyPlan[day] else { return nil }
        return recipes.first { $0.id == id }
    }

    var shoppingItems: [RecipeIngredient] {
        var grouped: [String: RecipeIngredient] = [:]
        for recipeID in Set(weeklyPlan.values) {
            guard let recipe = recipes.first(where: { $0.id == recipeID }) else { continue }
            for item in recipe.ingredients where !pantryIngredientIDs.contains(item.ingredientID) {
                if let existing = grouped[item.ingredientID] {
                    grouped[item.ingredientID] = RecipeIngredient(
                        ingredientID: item.ingredientID,
                        name: item.name,
                        amount: existing.amount + " + " + item.amount
                    )
                } else {
                    grouped[item.ingredientID] = item
                }
            }
        }
        return grouped.values.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }

    func toggleShoppingItem(_ item: RecipeIngredient) {
        if checkedShoppingItems.contains(item.ingredientID) {
            checkedShoppingItems.remove(item.ingredientID)
        } else {
            checkedShoppingItems.insert(item.ingredientID)
        }
        defaults.set(Array(checkedShoppingItems), forKey: shoppingChecksKey)
    }

    func usePantryForRecipeSearch() {
        selectedIngredientIDs = pantryIngredientIDs
    }

    var freeUsesRemaining: Int {
        resetDailyUsageIfNeeded()
        return max(0, 1 - defaults.integer(forKey: usageCountKey))
    }

    func canOpenRecipe(isPremium: Bool) -> Bool {
        if isPremium { return true }
        resetDailyUsageIfNeeded()

        let used = defaults.integer(forKey: usageCountKey)
        if used < 1 {
            defaults.set(used + 1, forKey: usageCountKey)
            return true
        }

        let reward = defaults.integer(forKey: rewardCountKey)
        if reward > 0 {
            defaults.set(reward - 1, forKey: rewardCountKey)
            return true
        }

        return false
    }

    func grantRewardedRecipe() {
        resetDailyUsageIfNeeded()
        defaults.set(defaults.integer(forKey: rewardCountKey) + 1, forKey: rewardCountKey)
    }

    func makeRandomSuggestion() {
        switch selectedRandomMode {
        case .cook:
            randomOrderSuggestion = nil
            let eligible = recipes.filter {
                $0.ingredients.count >= 3 &&
                $0.instructions.count >= 4 &&
                Set($0.ingredients.map(\.ingredientID)).count == $0.ingredients.count &&
                $0.id != randomRecipe?.id
            }
            randomRecipe = eligible.randomElement() ?? recipes.randomElement()
        case .order:
            randomRecipe = nil
            randomOrderSuggestion = [
                "Döner dürüm ve ayran",
                "Lahmacun ve salata",
                "Karışık pide",
                "Izgara tavuk menü",
                "Ev yemeği tabağı",
                "Mercimek çorbası ve pide",
                "Sebzeli noodle",
                "Margarita pizza",
                "Köfte ekmek",
                "Tavuklu pilav",
                "Kebap ve bulgur pilavı",
                "Falafel dürüm",
                "Sushi menü",
                "Mantı",
                "Etli kuru fasulye ve pilav"
            ].randomElement()
        }
    }

    private func resetDailyUsageIfNeeded() {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        let today = formatter.string(from: Date())
        if defaults.string(forKey: usageDateKey) != today {
            defaults.set(today, forKey: usageDateKey)
            defaults.set(0, forKey: usageCountKey)
            defaults.set(0, forKey: rewardCountKey)
        }
    }

    private func savePlan() {
        defaults.set(Dictionary(uniqueKeysWithValues: weeklyPlan.map {
            (String($0.key), $0.value)
        }), forKey: weeklyPlanKey)
        let validIDs = Set(shoppingItems.map(\.ingredientID))
        checkedShoppingItems.formIntersection(validIDs)
        defaults.set(Array(checkedShoppingItems), forKey: shoppingChecksKey)
    }

    private static func decodePlan(_ dictionary: [String: Any]) -> [Int: String] {
        Dictionary(uniqueKeysWithValues: dictionary.compactMap { key, value in
            guard let day = Int(key), let recipeID = value as? String else { return nil }
            return (day, recipeID)
        })
    }
}

private extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from fileName: String) -> T {
        guard
            let url = url(
                forResource: fileName.replacingOccurrences(of: ".json", with: ""),
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(T.self, from: data)
        else {
            fatalError("\(fileName) uygulama paketinde okunamadı.")
        }
        return decoded
    }
}
