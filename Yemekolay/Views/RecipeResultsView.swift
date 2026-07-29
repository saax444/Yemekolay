import SwiftUI

struct RecipeResultsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        ZStack {
            AppBackground()

            let results = appState.matches()

            if results.isEmpty {
                ContentUnavailableView(
                    "Uygun tarif bulunamadı",
                    systemImage: "fork.knife.circle",
                    description: Text("Bir veya iki temel malzeme daha ekleyerek tekrar deneyin.")
                )
            } else {
                List {
                    ForEach(Array(results.enumerated()), id: \.element.id) { index, match in
                        NavigationLink {
                            RecipeGateView(recipe: match.recipe)
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(match.recipe.name)
                                            .font(.headline)
                                        Text(match.recipe.category)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text("%\(match.matchPercentage)")
                                        .font(.headline)
                                        .foregroundStyle(match.matchPercentage >= 80 ? .green : .orange)
                                }

                                ProgressView(value: Double(match.matchPercentage), total: 100)
                                    .tint(match.matchPercentage >= 80 ? .green : .orange)

                                if !match.missingIngredients.isEmpty {
                                    Text("Eksik: " + match.missingIngredients.prefix(4).map(\.name).joined(separator: ", "))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        .listRowBackground(Color.clear)

                        if !purchaseManager.isPremium, index == 4 {
                            BannerAdArea()
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .padding(.vertical, 8)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
        }
        .navigationTitle("Uygun Tarifler")
    }
}
