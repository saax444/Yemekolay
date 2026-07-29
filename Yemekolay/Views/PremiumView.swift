import SwiftUI
import StoreKit

struct PremiumView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 18) {
                    GlassCard {
                        VStack(spacing: 14) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 58))
                                .foregroundStyle(.orange)

                            Text("Yemekolay Premium")
                                .font(.largeTitle.bold())

                            Text("Tariflere sınırsız eriş, reklamları kaldır ve mutfakta kesintisiz ilerle.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Sınırsız tarif görüntüleme", systemImage: "infinity")
                            Label("Reklamsız kullanım", systemImage: "nosign")
                            Label("Ödüllü reklam beklemeden tarif açma", systemImage: "bolt.fill")
                            Label("Tüm tarif kütüphanesine kesintisiz erişim", systemImage: "books.vertical.fill")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ücretsiz sürüm")
                                .font(.headline)
                            Label("Her gün 1 ücretsiz tarif detayı", systemImage: "1.circle.fill")
                            Label("Reklam izleyerek ek tarif hakkı", systemImage: "play.rectangle.fill")
                            Label("Malzeme arama, öneriler ve favoriler", systemImage: "checkmark.circle.fill")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let product = purchaseManager.products.first {
                        Button {
                            Task { await purchaseManager.purchase(product) }
                        } label: {
                            Text("\(product.displayPrice) / ay ile Premium'a Geç")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    } else {
                        GlassCard {
                            Text("App Store abonelik ürünü henüz yüklenmedi. App Store Connect'te product ID oluşturulduğunda fiyat burada görünecek.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text("Abonelik otomatik yenilenir. Dönem bitiminden en az 24 saat önce iptal edilmezse yenilenir.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Satın Alımları Geri Yükle") {
                        Task { await purchaseManager.restore() }
                    }

                    Link("Kullanım Koşulları", destination: URL(string: "https://saax444.github.io/Yemekolay/terms/")!)
                    Link("Gizlilik Politikası", destination: URL(string: "https://saax444.github.io/Yemekolay/privacy/")!)
                }
                .padding()
            }
        }
        .navigationTitle("Premium")
    }
}
