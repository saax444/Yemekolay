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
                    Link("Gizlilik Politikası", destination: URL(string: "https://saybir.net/yemekolay/privacy")!)
                    Link("Kullanım Koşulları", destination: URL(string: "https://saybir.net/yemekolay/terms")!)
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
