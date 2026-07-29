import SwiftUI

struct RandomSuggestionView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 18) {
                    Picker("Öneri türü", selection: $appState.selectedRandomMode) {
                        ForEach(AppState.RandomMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    if appState.selectedRandomMode == .cook {
                        cookingContent
                    } else {
                        orderContent
                    }

                    Button {
                        appState.makeRandomSuggestion()
                    } label: {
                        Label("Yeni Öneri Ver", systemImage: "dice.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)

                    if !purchaseManager.isPremium {
                        BannerAdArea()
                            .frame(height: 50)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            if appState.randomRecipe == nil && appState.randomOrderSuggestion == nil {
                appState.makeRandomSuggestion()
            }
        }
        .onChange(of: appState.selectedRandomMode) {
            appState.makeRandomSuggestion()
        }
        .navigationTitle("Bugün Ne Yesem?")
    }

    @ViewBuilder
    private var cookingContent: some View {
        if let recipe = appState.randomRecipe {
            RecipeSummaryCard(recipe: recipe)

            NavigationLink {
                RecipeGateView(recipe: recipe)
            } label: {
                Label("Tarifi Gör", systemImage: "book.pages")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        } else {
            ProgressView("Tarif seçiliyor...")
                .frame(maxWidth: .infinity)
                .padding(40)
        }
    }

    @ViewBuilder
    private var orderContent: some View {
        GlassCard {
            VStack(spacing: 14) {
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(.orange)

                Text(appState.randomOrderSuggestion ?? "Sipariş önerisi hazırlanıyor")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text("Yakınındaki sipariş uygulamasında bu seçeneği arayabilirsin.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
