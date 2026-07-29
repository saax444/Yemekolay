import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager
    let recipe: Recipe

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    RecipeSummaryCard(recipe: recipe)

                    Text(recipe.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                        .padding(.horizontal, 4)

                    GlassCard {
                        HStack {
                            Label("\(recipe.preparationMinutes) dk hazırlık", systemImage: "clock")
                            Spacer()
                            Label("\(recipe.cookingMinutes) dk pişirme", systemImage: "flame")
                        }
                        .font(.subheadline)
                    }

                    Button {
                        appState.toggleFavorite(recipe)
                    } label: {
                        Label(
                            appState.isFavorite(recipe) ? "Favorilerden Çıkar" : "Favorilere Ekle",
                            systemImage: appState.isFavorite(recipe) ? "heart.fill" : "heart"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Malzemeler")
                                .font(.title3.bold())

                            ForEach(recipe.ingredients, id: \.self) { item in
                                HStack(alignment: .firstTextBaseline) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.orange)
                                    Text(item.name)
                                    Spacer()
                                    Text(item.amount)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Hazırlanışı")
                                .font(.title3.bold())

                            ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(index + 1)")
                                        .font(.headline)
                                        .frame(width: 32, height: 32)
                                        .background(Color.orange.opacity(0.14), in: Circle())

                                    Text(step)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Label("Püf Noktaları", systemImage: "lightbulb.max.fill")
                                .font(.title3.bold())
                                .foregroundStyle(.primary)

                            ForEach(recipe.tips, id: \.self) { tip in
                                Label {
                                    Text(tip)
                                } icon: {
                                    Image(systemName: "sparkles")
                                        .foregroundStyle(.orange)
                                }
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Saklama", systemImage: "refrigerator.fill")
                                .font(.title3.bold())
                            Text(recipe.storage)
                                .foregroundStyle(.secondary)
                                .lineSpacing(3)
                        }
                    }

                    if !purchaseManager.isPremium {
                        BannerAdArea()
                    }
                }
                .padding()
            }
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
