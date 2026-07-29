import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager
    let recipe: Recipe
    @State private var servingCount: Int
    @State private var showPremium = false

    init(recipe: Recipe) {
        self.recipe = recipe
        _servingCount = State(initialValue: recipe.servings)
    }

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

                    GlassCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Label("Porsiyon", systemImage: "person.2.fill")
                                    .font(.headline)
                                Text(purchaseManager.isPremium ? "Ölçüler otomatik hesaplanır" : "Premium ile ölçüleri otomatik ayarla")
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Stepper("\(servingCount)", value: $servingCount, in: 1...12)
                                .labelsHidden()
                                .disabled(!purchaseManager.isPremium)
                            Text("\(servingCount) kişilik")
                                .font(.subheadline.weight(.semibold))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if !purchaseManager.isPremium { showPremium = true }
                        }
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
                                    Text(scaledAmount(item.amount))
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

                }
                .padding()
            }
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPremium) {
            NavigationStack { PremiumView() }
        }
    }

    private func scaledAmount(_ amount: String) -> String {
        guard servingCount != recipe.servings, recipe.servings > 0 else { return amount }
        let ratio = Double(servingCount) / Double(recipe.servings)
        let pattern = #"^(\d+(?:[.,]\d+)?|\d+/\d+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: amount, range: NSRange(amount.startIndex..., in: amount)),
              let range = Range(match.range(at: 1), in: amount) else { return amount }
        let raw = String(amount[range]).replacingOccurrences(of: ",", with: ".")
        let value: Double
        if raw.contains("/") {
            let parts = raw.split(separator: "/").compactMap { Double($0) }
            guard parts.count == 2, parts[1] != 0 else { return amount }
            value = parts[0] / parts[1]
        } else {
            guard let parsed = Double(raw) else { return amount }
            value = parsed
        }
        let scaled = value * ratio
        let formatted = scaled.rounded() == scaled
            ? String(Int(scaled))
            : String(format: "%.1f", scaled).replacingOccurrences(of: ".", with: ",")
        return formatted + amount[range.upperBound...]
    }
}
