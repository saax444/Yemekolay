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

    private let defaults = UserDefaults.standard
    private let usageDateKey = "usage.date"
    private let usageCountKey = "usage.count"
    private let rewardCountKey = "usage.reward"
    private let favoritesKey = "favorites"

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
        resetDailyUsageIfNeeded()
    }

    var filteredIngredients: [Ingredient] {
        let query = SearchNormalizer.normalize(searchText)
        let source: [Ingredient]

        if query.isEmpty {
            source = Array(ingredients.prefix(180))
        } else {
            source = ingredients.filter { ingredient in
                SearchNormalizer.normalize(ingredient.name).contains(query) ||
                ingredient.searchTokens.contains {
                    SearchNormalizer.normalize($0).contains(query)
                }
            }
        }
        return Array(source.prefix(300))
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
            randomRecipe = recipes.randomElement()
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
