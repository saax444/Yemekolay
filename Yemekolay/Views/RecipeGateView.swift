import SwiftUI

struct RecipeGateView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @EnvironmentObject private var adManager: AdManager

    let recipe: Recipe

    @State private var unlocked = false
    @State private var showPremium = false
    @State private var showLimitMessage = false

    var body: some View {
        Group {
            if unlocked || purchaseManager.isPremium {
                RecipeDetailView(recipe: recipe)
            } else {
                ZStack {
                    AppBackground()

                    VStack(spacing: 18) {
                        RecipeSummaryCard(recipe: recipe)

                        GlassCard {
                            VStack(spacing: 14) {
                                Image(systemName: "lock.circle.fill")
                                    .font(.system(size: 56))
                                    .foregroundStyle(.orange)

                                Text("Tarifi görüntüle")
                                    .font(.title2.bold())

                                Text("Günlük ücretsiz hakkını kullanabilir, reklam izleyerek bir tarif hakkı kazanabilir veya Premium'a geçebilirsin.")
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.secondary)

                                Button(appState.freeUsesRemaining > 0 ? "Ücretsiz Hakkımla Aç" : "Tarifi Aç") {
                                    if appState.canOpenRecipe(isPremium: purchaseManager.isPremium) {
                                        adManager.showInterstitial {
                                            unlocked = true
                                        }
                                    } else {
                                        showLimitMessage = true
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.orange)

                                Button(adManager.isRewardedReady ? "Reklam İzle ve Tarifi Aç" : "Reklam Hazırlanıyor…") {
                                    adManager.showRewarded {
                                        appState.grantRewardedRecipe()
                                        _ = appState.canOpenRecipe(isPremium: false)
                                        unlocked = true
                                    }
                                }
                                .buttonStyle(.bordered)
                                .disabled(!adManager.isRewardedReady)

                                Button("Premium'a Geç") {
                                    showPremium = true
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showPremium) {
            NavigationStack { PremiumView() }
        }
        .alert("Günlük ücretsiz hakkın bitti", isPresented: $showLimitMessage) {
            Button("Reklam İzle") {
                adManager.showRewarded {
                    appState.grantRewardedRecipe()
                    _ = appState.canOpenRecipe(isPremium: false)
                    unlocked = true
                }
            }
            Button("Premium") { showPremium = true }
            Button("Vazgeç", role: .cancel) {}
        } message: {
            Text("Bir reklam izleyerek bu tarifi açabilirsin.")
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
