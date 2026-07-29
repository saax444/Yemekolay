import Foundation

struct Ingredient: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let category: String
    let searchTokens: [String]
}
