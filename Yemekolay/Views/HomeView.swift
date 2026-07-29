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
                KitchenHubView()
            } label: {
                actionCard(
                    title: "Mutfak Planım",
                    subtitle: "Kilerini düzenle, haftanı planla, listeni hazırla",
                    symbol: "calendar.badge.checkmark"
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

struct KitchenHubView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @State private var section = 0
    @State private var pantrySearch = ""
    @State private var showPremium = false

    private let days = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"]

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 12) {
                Picker("Mutfak planı", selection: $section) {
                    Text("Kilerim").tag(0)
                    Text("Haftam").tag(1)
                    Text("Alışveriş").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if section == 0 {
                    pantryView
                } else if purchaseManager.isPremium {
                    section == 1 ? AnyView(planView) : AnyView(shoppingView)
                } else {
                    premiumGate
                }
            }
            .padding(.top, 8)
        }
        .navigationTitle("Mutfak Planım")
        .sheet(isPresented: $showPremium) {
            NavigationStack { PremiumView() }
        }
    }

    private var pantryView: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Kilerinde olanı ara", text: $pantrySearch)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding(14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
            .padding()

            let query = SearchNormalizer.normalize(pantrySearch)
            let items = appState.ingredients.filter {
                query.isEmpty
                    ? appState.pantryIngredientIDs.contains($0.id)
                    : SearchNormalizer.normalize($0.name).contains(query)
            }
            List(items.prefix(query.isEmpty ? 150 : 100)) { ingredient in
                Button {
                    appState.togglePantryIngredient(ingredient)
                } label: {
                    Label(ingredient.name, systemImage: appState.pantryIngredientIDs.contains(ingredient.id) ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(appState.pantryIngredientIDs.contains(ingredient.id) ? .orange : .primary)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .overlay {
                if query.isEmpty && appState.pantryIngredientIDs.isEmpty {
                    ContentUnavailableView("Kilerin boş", systemImage: "cabinet", description: Text("Arama yaparak evde bulunan malzemeleri ekle."))
                }
            }

            if !appState.pantryIngredientIDs.isEmpty {
                NavigationLink {
                    RecipeResultsView()
                        .onAppear { appState.usePantryForRecipeSearch() }
                } label: {
                    Label("Kilerimle Tarif Bul", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                        .padding(14)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .padding()
            }
        }
    }

    private var planView: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(days.indices, id: \.self) { day in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(days[day]).font(.headline)
                            if let recipe = appState.plannedRecipe(for: day) {
                                HStack {
                                    Image(systemName: recipe.imageSymbol)
                                        .foregroundStyle(.orange)
                                    VStack(alignment: .leading) {
                                        Text(recipe.name).font(.subheadline.weight(.semibold))
                                        Text("\(recipe.preparationMinutes + recipe.cookingMinutes) dk")
                                            .font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Button(role: .destructive) { appState.removeFromPlan(day: day) } label: {
                                        Image(systemName: "xmark.circle.fill")
                                    }
                                }
                            } else {
                                Menu {
                                    ForEach(appState.favoriteRecipes.isEmpty ? Array(appState.recipes.prefix(30)) : appState.favoriteRecipes) { recipe in
                                        Button(recipe.name) { appState.addToPlan(recipe, day: day) }
                                    }
                                } label: {
                                    Label("Tarif ekle", systemImage: "plus.circle")
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }

    private var shoppingView: some View {
        Group {
            if appState.shoppingItems.isEmpty {
                ContentUnavailableView("Listen hazır değil", systemImage: "cart", description: Text("Haftalık planına tarif eklediğinde eksik malzemeler burada birleşir."))
            } else {
                List(appState.shoppingItems, id: \.ingredientID) { item in
                    Button { appState.toggleShoppingItem(item) } label: {
                        HStack {
                            Image(systemName: appState.checkedShoppingItems.contains(item.ingredientID) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(.orange)
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Text(item.amount).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
            }
        }
    }

    private var premiumGate: some View {
        VStack(spacing: 18) {
            Spacer()
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 58)).foregroundStyle(.orange)
            Text("Haftanı tek dokunuşla planla").font(.title2.bold())
            Text("Premium ile tariflerini günlere yerleştir; eksik malzemeler otomatik alışveriş listesine dönüşsün.")
                .multilineTextAlignment(.center).foregroundStyle(.secondary)
            Button("Premium'u İncele") { showPremium = true }
                .buttonStyle(.borderedProminent).tint(.orange)
            Spacer()
        }
        .padding(28)
    }
}
