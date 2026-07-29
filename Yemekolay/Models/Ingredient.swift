import Foundation

struct Ingredient: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let category: String
    let searchTokens: [String]
}

extension Ingredient {
    var symbolName: String {
        switch category {
        case "Sebze": "carrot.fill"
        case "Meyve": "apple.logo"
        case "Et ve Şarküteri": "fork.knife"
        case "Deniz Ürünü": "fish.fill"
        case "Süt Ürünü ve Yumurta": "waterbottle.fill"
        case "Tahıl ve Makarna": "takeoutbag.and.cup.and.straw.fill"
        case "Bakliyat": "leaf.fill"
        case "Baharat": "sparkles"
        case "Kuruyemiş ve Tohum": "circle.hexagongrid.fill"
        case "Dünya Mutfağı": "globe.europe.africa.fill"
        default: "basket.fill"
        }
    }

    var tintName: String {
        switch category {
        case "Sebze", "Bakliyat": "green"
        case "Meyve": "red"
        case "Et ve Şarküteri": "brown"
        case "Deniz Ürünü": "blue"
        case "Süt Ürünü ve Yumurta": "yellow"
        case "Baharat": "orange"
        default: "accent"
        }
    }
}
