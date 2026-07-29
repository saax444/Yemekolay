import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            AppBackground()

            if appState.favoriteRecipes.isEmpty {
                ContentUnavailableView(
                    "Favori tarif yok",
                    systemImage: "heart",
                    description: Text("Beğendiğin tarifleri kalp simgesinden kaydedebilirsin.")
                )
            } else {
                List(appState.favoriteRecipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        RecipeSummaryCard(recipe: recipe)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favoriler")
    }
}
