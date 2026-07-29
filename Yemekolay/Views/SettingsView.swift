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
                    NavigationLink("Mutfak Planım") {
                        KitchenHubView()
                    }
                }

                Section("Yasal") {
                    Link("Gizlilik Politikası", destination: URL(string: "https://saax444.github.io/Yemekolay/privacy/")!)
                    Link("Kullanım Koşulları", destination: URL(string: "https://saax444.github.io/Yemekolay/terms/")!)
                    Link("Destek", destination: URL(string: "https://saax444.github.io/Yemekolay/support/")!)
                }

                Section("Uygulama") {
                    LabeledContent("Dil", value: "Türkçe")
                    LabeledContent("Sürüm", value: "1.0")
                    LabeledContent("Malzeme", value: "1.062")
                    LabeledContent("Tarif", value: "1.000")
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Ayarlar")
    }
}
