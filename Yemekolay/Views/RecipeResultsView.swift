import SwiftUI

struct RecipeResultsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @State private var maximumMinutes = 120
    @State private var maximumMissing = 99
    @State private var selectedDifficulty = "Tümü"
    @State private var showFilters = false
    @State private var showPremium = false

    var body: some View {
        ZStack {
            AppBackground()

            let results = filteredResults

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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showFilters = true } label: {
                    Label("Filtrele", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(isPresented: $showFilters) {
            NavigationStack {
                Form {
                    Section("Hazırlama süresi") {
                        Picker("En fazla", selection: $maximumMinutes) {
                            Text("30 dk").tag(30)
                            Text("60 dk").tag(60)
                            Text("90 dk").tag(90)
                            Text("Tümü").tag(120)
                        }
                        .pickerStyle(.segmented)
                    }
                    Section("Premium filtreleri") {
                        Picker("Eksik malzeme", selection: $maximumMissing) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("Tümü").tag(99)
                        }
                        .disabled(!purchaseManager.isPremium)
                        Picker("Zorluk", selection: $selectedDifficulty) {
                            ForEach(["Tümü", "Kolay", "Orta", "Zor"], id: \.self) { Text($0) }
                        }
                        .disabled(!purchaseManager.isPremium)
                        if !purchaseManager.isPremium {
                            Button("Gelişmiş Filtreleri Aç") {
                                showFilters = false
                                showPremium = true
                            }
                        }
                    }
                }
                .navigationTitle("Tarifleri Filtrele")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Bitti") { showFilters = false }
                    }
                }
            }
        }
        .sheet(isPresented: $showPremium) {
            NavigationStack { PremiumView() }
        }
    }

    private var filteredResults: [RecipeMatch] {
        appState.matches().filter { match in
            let total = match.recipe.preparationMinutes + match.recipe.cookingMinutes
            let timeMatches = maximumMinutes == 120 || total <= maximumMinutes
            guard timeMatches else { return false }
            guard purchaseManager.isPremium else { return true }
            let missingMatches = maximumMissing == 99 || match.missingIngredients.count <= maximumMissing
            let difficultyMatches = selectedDifficulty == "Tümü" || match.recipe.difficulty == selectedDifficulty
            return missingMatches && difficultyMatches
        }
    }
}
