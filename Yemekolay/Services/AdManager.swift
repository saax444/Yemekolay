import GoogleMobileAds
import SwiftUI
import UIKit

enum AdConfiguration {
    static let bannerID = "ca-app-pub-3233573743391367/4445190199"
    static let interstitialID = "ca-app-pub-3233573743391367/9437662425"
    static let rewardedID = "ca-app-pub-3233573743391367/7825886210"
}

@MainActor
final class AdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    @Published private(set) var isInterstitialReady = false
    @Published private(set) var isRewardedReady = false

    private var interstitial: InterstitialAd?
    private var rewarded: RewardedAd?
    private var lastInterstitialDate: Date?
    private var sessionStartedAt = Date()
    private var completedInterstitial: (() -> Void)?
    private var completedReward: (() -> Void)?

    private let minimumInterstitialInterval: TimeInterval = 300
    private let firstSessionGracePeriod: TimeInterval = 120

    override init() {
        super.init()
        MobileAds.shared.start()
        loadInterstitial()
        loadRewarded()
    }

    func showInterstitial(completion: @escaping () -> Void) {
        guard
            let ad = interstitial,
            let presenter = Self.topViewController,
            Date().timeIntervalSince(sessionStartedAt) >= firstSessionGracePeriod,
            lastInterstitialDate.map({ Date().timeIntervalSince($0) >= minimumInterstitialInterval }) ?? true
        else {
            completion()
            if interstitial == nil { loadInterstitial() }
            return
        }

        completedInterstitial = completion
        interstitial = nil
        isInterstitialReady = false
        lastInterstitialDate = Date()
        ad.fullScreenContentDelegate = self
        ad.present(from: presenter)
    }

    func showRewarded(onReward: @escaping () -> Void) {
        guard let ad = rewarded, let presenter = Self.topViewController else {
            loadRewarded()
            return
        }

        completedReward = onReward
        rewarded = nil
        isRewardedReady = false
        ad.fullScreenContentDelegate = self
        ad.present(from: presenter) { [weak self] in
            self?.completedReward?()
            self?.completedReward = nil
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        completedInterstitial?()
        completedInterstitial = nil
        loadInterstitial()
        loadRewarded()
    }

    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        completedInterstitial?()
        completedInterstitial = nil
        completedReward = nil
        loadInterstitial()
        loadRewarded()
    }

    private func loadInterstitial() {
        InterstitialAd.load(
            with: AdConfiguration.interstitialID,
            request: Request()
        ) { [weak self] ad, _ in
            Task { @MainActor in
                self?.interstitial = ad
                self?.isInterstitialReady = ad != nil
            }
        }
    }

    private func loadRewarded() {
        RewardedAd.load(
            with: AdConfiguration.rewardedID,
            request: Request()
        ) { [weak self] ad, _ in
            Task { @MainActor in
                self?.rewarded = ad
                self?.isRewardedReady = ad != nil
            }
        }
    }

    fileprivate static var topViewController: UIViewController? {
        let root = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .rootViewController

        var current = root
        while let presented = current?.presentedViewController {
            current = presented
        }
        return current
    }
}

struct BannerAdArea: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = AdConfiguration.bannerID
        banner.rootViewController = AdManager.topViewController
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        uiView.rootViewController = AdManager.topViewController
    }
}
