import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let monthlyProductID = "com.azizsaybir.yemekolay.premium.monthly"

    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var errorMessage: String?

    var isPremium: Bool {
        purchasedProductIDs.contains(Self.monthlyProductID)
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: [Self.monthlyProductID])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            guard case .success(let verification) = result else { return }
            let transaction = try verified(verification)
            await transaction.finish()
            await updatePurchasedProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func restore() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updatePurchasedProducts() async {
        var active: Set<String> = []
        for await result in Transaction.currentEntitlements {
            if let transaction = try? verified(result), transaction.revocationDate == nil {
                active.insert(transaction.productID)
            }
        }
        purchasedProductIDs = active
    }

    private func verified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let value): return value
        case .unverified: throw StoreError.failedVerification
        }
    }

    enum StoreError: Error { case failedVerification }
}
