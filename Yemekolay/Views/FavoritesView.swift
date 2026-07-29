import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                Group {
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

                if !purchaseManager.isPremium {
                    BannerAdArea()
                        .frame(height: 50)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
        }
        .navigationTitle("Favoriler")
    }
}
