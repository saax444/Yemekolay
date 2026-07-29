import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    header
                    usageCard
                    mainActions

                    if !purchaseManager.isPremium {
                        BannerAdArea()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Yemekolay")
        .navigationBarTitleDisplayMode(.large)
    }

    private var header: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Image("BrandLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)
                    .accessibilityLabel("Yemekolay")
                Text("Evde ne varsa,")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.secondary)
                Text("yemeğin hazır.")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                Text("Malzemelerini seç, sana en uygun tarifleri eksik malzemeleriyle birlikte gösterelim.")
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var usageCard: some View {
        GlassCard {
            HStack {
                Image(systemName: purchaseManager.isPremium ? "crown.fill" : "fork.knife")
                    .font(.title3)
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: 3) {
                    Text(purchaseManager.isPremium ? "Premium aktif" : "Günlük kullanım")
                        .font(.headline)
                    Text(purchaseManager.isPremium ? "Sınırsız tarif ve reklamsız kullanım" : "\(appState.freeUsesRemaining) ücretsiz tarif hakkın kaldı")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }

    private var mainActions: some View {
        VStack(spacing: 14) {
            NavigationLink {
                IngredientPickerView()
            } label: {
                actionCard(
                    title: "Malzemelerimle Yemek Bul",
                    subtitle: "Temizlenmiş kapsamlı malzeme kataloğunda ara",
                    symbol: "magnifyingglass"
                )
            }

            NavigationLink {
                RandomSuggestionView()
            } label: {
                actionCard(
                    title: "Bugün Ne Yesem?",
                    subtitle: "Pişirme veya sipariş önerisi al",
                    symbol: "dice.fill"
                )
            }

            NavigationLink {
                PremiumView()
            } label: {
                actionCard(
                    title: "Yemekolay Premium",
                    subtitle: "Sınırsız tarif ve reklamsız kullanım",
                    symbol: "crown.fill"
                )
            }
        }
        .buttonStyle(.plain)
    }

    private func actionCard(title: String, subtitle: String, symbol: String) -> some View {
        GlassCard {
            HStack(spacing: 14) {
                Image(systemName: symbol)
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .background(Color.orange.opacity(0.14), in: Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline)
                    Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
        }
    }
}
