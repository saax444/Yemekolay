import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            AppBackground()

            List {
                Section("Hesap") {
                    NavigationLink("Yemekolay Premium") {
                        PremiumView()
                    }
                }

                Section("Yasal") {
                    Link("Gizlilik Politikası", destination: URL(string: "https://yemekolay-destek.saax-444.chatgpt.site/privacy")!)
                    Link("Kullanım Koşulları", destination: URL(string: "https://yemekolay-destek.saax-444.chatgpt.site/terms")!)
                    Link("Destek", destination: URL(string: "https://yemekolay-destek.saax-444.chatgpt.site/support")!)
                }

                Section("Uygulama") {
                    LabeledContent("Dil", value: "Türkçe")
                    LabeledContent("Sürüm", value: "1.0")
                    LabeledContent("Malzeme", value: "3.200")
                    LabeledContent("Tarif", value: "1.000")
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Ayarlar")
    }
}
