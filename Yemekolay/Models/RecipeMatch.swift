import Foundation

struct RecipeMatch: Identifiable {
    let recipe: Recipe
    let matchPercentage: Int
    let missingIngredients: [RecipeIngredient]
    var id: String { recipe.id }
}
