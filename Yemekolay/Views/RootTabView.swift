import SwiftUI

struct RootTabView: View {
    @State private var selectedTab: Int

    init() {
#if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        let requestedTab = arguments
            .first(where: { $0.hasPrefix("--screenshot-tab=") })
            .flatMap { Int($0.replacingOccurrences(of: "--screenshot-tab=", with: "")) }
        _selectedTab = State(initialValue: requestedTab ?? 0)
#else
        _selectedTab = State(initialValue: 0)
#endif
    }

    var body: some View {
        Group {
#if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--screenshot-premium") {
                NavigationStack { PremiumView() }
            } else {
                tabs
            }
#else
            tabs
#endif
        }
    }

    private var tabs: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { HomeView() }
                .tabItem { Label("Ana Sayfa", systemImage: "house") }
                .tag(0)

            NavigationStack { IngredientPickerView() }
                .tabItem { Label("Malzemeler", systemImage: "carrot") }
                .tag(1)

            NavigationStack { RandomSuggestionView() }
                .tabItem { Label("Rastgele", systemImage: "dice") }
                .tag(2)

            NavigationStack { FavoritesView() }
                .tabItem { Label("Favoriler", systemImage: "heart") }
                .tag(3)

            NavigationStack { SettingsView() }
                .tabItem { Label("Ayarlar", systemImage: "gearshape") }
                .tag(4)
        }
        .tint(.orange)
    }
}
