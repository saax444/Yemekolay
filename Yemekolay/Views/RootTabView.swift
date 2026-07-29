import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Ana Sayfa", systemImage: "house") }

            NavigationStack { IngredientPickerView() }
                .tabItem { Label("Malzemeler", systemImage: "carrot") }

            NavigationStack { RandomSuggestionView() }
                .tabItem { Label("Rastgele", systemImage: "dice") }

            NavigationStack { FavoritesView() }
                .tabItem { Label("Favoriler", systemImage: "heart") }

            NavigationStack { SettingsView() }
                .tabItem { Label("Ayarlar", systemImage: "gearshape") }
        }
        .tint(.orange)
    }
}
