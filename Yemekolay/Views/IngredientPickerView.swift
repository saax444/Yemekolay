import SwiftUI

struct IngredientPickerView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                searchHeader

                List(appState.filteredIngredients) { ingredient in
                    Button {
                        appState.toggleIngredient(ingredient)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: ingredient.symbolName)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(iconColor(for: ingredient))
                                .frame(width: 38, height: 38)
                                .background(iconColor(for: ingredient).opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                            VStack(alignment: .leading, spacing: 3) {
                                Text(ingredient.name)
                                    .foregroundStyle(.primary)
                                Text(ingredient.category)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: appState.selectedIngredientIDs.contains(ingredient.id) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(appState.selectedIngredientIDs.contains(ingredient.id) ? .orange : .secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)

                if !purchaseManager.isPremium {
                    BannerAdArea()
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                RecipeResultsView()
            } label: {
                Text("Uygun Tarifleri Göster")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(appState.selectedIngredientIDs.isEmpty ? Color.gray.opacity(0.4) : Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .disabled(appState.selectedIngredientIDs.isEmpty)
            .padding()
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Malzemeler")
    }

    private func iconColor(for ingredient: Ingredient) -> Color {
        switch ingredient.tintName {
        case "green": .green
        case "red": .red
        case "brown": .brown
        case "blue": .blue
        case "yellow": .yellow
        case "orange": .orange
        default: .accentColor
        }
    }

    private var searchHeader: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Patates, yumurta, kıyma ara", text: $appState.searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                if !appState.searchText.isEmpty {
                    Button {
                        appState.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            HStack {
                Text("\(appState.selectedIngredientIDs.count) malzeme seçildi")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                if !appState.selectedIngredientIDs.isEmpty {
                    Button("Temizle") {
                        appState.selectedIngredientIDs.removeAll()
                    }
                    .font(.subheadline)
                }
            }
        }
        .padding()
    }
}
