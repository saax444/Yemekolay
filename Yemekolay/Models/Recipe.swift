import Foundation

struct RecipeIngredient: Codable, Hashable {
    let ingredientID: String
    let name: String
    let amount: String
}

struct Recipe: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let category: String
    let description: String
    let ingredients: [RecipeIngredient]
    let instructions: [String]
    let tips: [String]
    let storage: String
    let preparationMinutes: Int
    let cookingMinutes: Int
    let servings: Int
    let difficulty: String
    let tags: [String]
    let imageSymbol: String
}
