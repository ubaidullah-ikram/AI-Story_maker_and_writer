import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdsShowCallBack {
  void onAdDismissedFullScreenContent();
  void onAdFailedToShowFullScreenContent();
  void onAdShowedFullScreenContent();
  void onAdFailedToLoad();
}

class AdManager {
  late AdsShowCallBack callback;

  static InterstitialAd? interstitialAd;
  static AppOpenAd? appOpenAd;
  static bool isInterstitialAdLoading = false;
  static bool isOpenAppAdLoading = false;
  static NativeAd? nativeAd;
  static bool isNativeAdLoaded = false;

  static void requestConsentForm() {
    final params = ConsentRequestParameters(
      consentDebugSettings: ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: ["96F02817EE8A9DBEE0B037F65B96A1E8"],
      ),
    );

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
          if (error != null) {
            log("Error showing consent form: ${error.message}");
          } else {
            log("Consent form dismissed");
          }
        });
        log("Consent information successfully updated.");
      },
      (FormError error) {
        log("Error updating consent information: ${error.message} ${error}");
      },
    );
  }

  static void loadInterstitialAd({
    required Function onAdLoaded,
    required Function onAdFailedToLoad,
    required BuildContext context,
    bool? istoShowLoadingAdAlert,
  }) {
    // Check if ad request is still active
    if (!_isAdRequestActive) {
      _isAdRequestActive = true;
    }

    InterstitialAd.load(
      adUnitId: AdIds.interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // صرف اگر request ابھی active ہے تو proceed کریں
          if (_isAdRequestActive) {
            log("✅ InterstitialAd Loaded");
            interstitialAd = ad;
            onAdLoaded();
          } else {
            // Ad request cancel تھا تو ad dispose کر دیں
            ad.dispose();
            log("🛑 Ad loaded but request was cancelled");
          }
        },
        onAdFailedToLoad: (error) {
          if (_isAdRequestActive) {
            onAdFailedToLoad();
            log("❌ InterstitialAd Failed to load: $error");
          }
          interstitialAd = null;
        },
      ),
    );
  }

  static void disposeInterstitial() {
    interstitialAd?.dispose();
    interstitialAd = null;
  }

  /// Show Interstitial Ad
  static void showInterstitialAd({
    Function? onDismiss,
    Function? onAddFailedToShow,
  }) {
    if (interstitialAd == null) {
      log("⚠ InterstitialAd not ready yet");
      onDismiss?.call();
      return;
    }

    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        log("Interstitial dismissed");
        ad.dispose();
        _isAdRequestActive = false;
        onDismiss?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log("Interstitial failed to show: $error");
        ad.dispose();
        _isAdRequestActive = false;
        onDismiss?.call();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  static void loadNativeAd({
    required void Function(NativeAd) onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) {
    final nativeAd = NativeAd(
      adUnitId: AdIds.nativeAdId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          onAdLoaded(ad as NativeAd);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailedToLoad(error);
        },
      ),
    );

    nativeAd.load();
  }

  static void showIntAd({required Function() onAdDissmissed}) {
    interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {},
      onAdImpression: (ad) {},
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
      },
      onAdDismissedFullScreenContent: (ad) {
        interstitialAd = null;
        onAdDissmissed();
        ad.dispose();
      },
      onAdClicked: (ad) {},
    );
    interstitialAd!.show();
  }

  /// Load AppOpenAd
  static void loadAppOpenAd({
    required Function() onAdLoaded,
    required Function() onAdFailedToLoad,
  }) {
    AppOpenAd.load(
      adUnitId: AdIds.appOpenApAdId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          onAdLoaded();
          log("AppOpenAd Loaded ✅");
          appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          onAdFailedToLoad();
          log("AppOpenAd Failed to load: $error");
        },
      ),
    );
  }

  /// Show ad (if available)
  static void showAppOpenAd({Function? onDismiss}) {
    if (appOpenAd == null) {
      log("⚠ No AppOpenAd available");
      onDismiss?.call();
      return;
    }

    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        log("Ad dismissed");
        ad.dispose();
        appOpenAd = null;
        onDismiss?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log("Ad failed to show: $error");
        ad.dispose();
        appOpenAd = null;
        onDismiss?.call();
      },
    );

    appOpenAd!.show();
    appOpenAd = null;
  }

  // ✅ Ab har screen ki apni banner ad hogi
  /// Load banner ad with callbacks - returns BannerAd instance
  static BannerAd? loadBannerAd({
    required BuildContext context,
    required Function(BannerAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) {
    BannerAd bannerAd = BannerAd(
      adUnitId: AdIds.bannerAdIdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Banner Loaded");
          onAdLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("❌ Banner Failed: $error");
          onAdFailedToLoad(error);
        },
      ),
    );

    bannerAd.load();
    return bannerAd;
  }

  /// Widget to show banner - ab specific banner ad pass karni hogi
  static Widget getBannerWidget(BannerAd? bannerAd) {
    if (bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }

  /// Dispose specific banner
  static void disposeBanner(BannerAd? bannerAd) {
    bannerAd?.dispose();
    debugPrint("🗑️ Banner Disposed");
  }

  static bool _isAdRequestActive = false;
  static void cancelAdRequest() {
    _isAdRequestActive = false;
    disposeInterstitial();
    log('🛑 Ad request cancelled');
  }
}

class AdIds {
  static String bannerAdIdId = Platform.isAndroid
      ? kDebugMode
            ? "ca-app-pub-3940256099942544/9214589741" // test android
            : "ca-app-pub-9804021071767799/5158345293"
      : kDebugMode
      ? "ca-app-pub-3940256099942544/2435281174" // test ios
      : "ca-app-pub-9804021071767799/3144579563";
  static String interstitialAdId = Platform.isAndroid
      ? kDebugMode
            ? "ca-app-pub-3940256099942544/1033173712" // test android
            : "ca-app-pub-9804021071767799/2264588642"
      : kDebugMode
      ? "ca-app-pub-3940256099942544/4411468910" // test ios
      : "ca-app-pub-9804021071767799/2532181950";
  static String appOpenApAdId = Platform.isAndroid
      ? kDebugMode
            ? "ca-app-pub-3940256099942544/9257395921" // test android
            : "ca-app-pub-9804021071767799/9951506971"
      : kDebugMode
      ? "ca-app-pub-3940256099942544/5575463023" // test ios
      : "ca-app-pub-9804021071767799/9540443431";
  static String nativeAdId = Platform.isAndroid
      ? kDebugMode
            ? "ca-app-pub-3940256099942544/2247696110" // test android
            : "ca-app-pub-9804021071767799/5821863733"
      : kDebugMode
      ? "ca-app-pub-3940256099942544/3986624511" // test ios
      : "ca-app-pub-9804021071767799/4668564164";
}
