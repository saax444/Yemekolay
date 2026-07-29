import SwiftUI

@main
struct YemekolayApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var purchaseManager = PurchaseManager()
    @StateObject private var adManager = AdManager()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(appState)
                .environmentObject(purchaseManager)
                .environmentObject(adManager)
                .task {
                    appState.loadDataIfNeeded()
                    await adManager.configureConsentAndAds()
                    await purchaseManager.loadProducts()
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
