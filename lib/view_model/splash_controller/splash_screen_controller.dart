import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:ai_story_writer/services/admanage_service.dart';
import 'package:ai_story_writer/services/query_manager_services.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view/bottom_navbar_view/bottom_navBar.dart';
import 'package:ai_story_writer/view/language_view/language_sc.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  Timer? _splashTimer;
  bool _navigated = false; // ensure ek hi dafa navigate ho

  var second_app_opened = "second_app_opened";
  Future<void> trackCompletedResult() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(second_app_opened) ?? 0;
    count++;
    await prefs.setString('ratingShowedOnce', 'no');
    await prefs.setInt(second_app_opened, count);
  }

  void loadSplashInterAd(BuildContext context) async {
    log('fn starts');

    // 2 sec splash delay
    Future.delayed(const Duration(seconds: 2), () {
      try {
        if (!Get.find<ProScreenController>().isUserPro.value) {
          loadSplashAppOpenAd();
        } else {
          log('===>  User is Pro isko jany do');
          _goNext();
        }
      } catch (e) {
        log('❌ Exception in loadSplashInterAd: $e');
        _goNext();
      }
    });

    // ✅ Hard timeout
    _splashTimer = Timer(const Duration(seconds: 6), () {
      if (!_navigated) {
        log('⏰ Timeout reached → navigating');
        _goNext();
      }
    });
  }

  void loadSplashAppOpenAd() {
    log('🚀 Loading AppOpen Ad on Splash');
    if (RemoteConfigService().open_ad_for_android) {
      AdManager.loadAppOpenAd(
        onAdLoaded: () {
          if (_navigated) {
            AdManager.appOpenAd?.dispose();
            return;
          }

          log('✅ AppOpenAd Loaded');
          Future.delayed(Duration(milliseconds: 200), () {
            AdManager.showAppOpenAd(onDismiss: _goNext);
          });
          // AdManager.showAppOpenAd(
          //   onDismiss: () {
          //     log('🚪 AppOpenAd dismissed');
          //     _goNext();
          //   },
          // );
        },
        onAdFailedToLoad: () {
          log('❌ AppOpenAd failed');
          _goNext();
        },
      );
    } else if (RemoteConfigService().open_ad_for_IOS) {
      AdManager.loadAppOpenAd(
        onAdLoaded: () {
          if (_navigated) {
            AdManager.appOpenAd?.dispose();
            return;
          }

          log('✅ AppOpenAd Loaded');
          Future.delayed(Duration(milliseconds: 200), () {
            AdManager.showAppOpenAd(onDismiss: _goNext);
          });
        },
        onAdFailedToLoad: () {
          log('❌ AppOpenAd failed');
          _goNext();
        },
      );
    } else {
      log('🚫 Splash ad disabled from remote config');
      _goNext();
    }
  }

  // androidInterAd(BuildContext context) {
  //   if (RemoteConfigService().intersitial_ads_for_andiod) {
  //     log('enabled ad splash intersitial from remote config ');
  //     AdManager.loadInterstitialAd(
  //       onAdLoaded: () {
  //         if (_navigated) {
  //           // agar already navigate ho gaya to ad ignore kar do
  //           AdManager.disposeInterstitial();
  //           return;
  //         }
  //         log('✅ Interstitial Loaded in Splash');
  //         _showAd();
  //       },
  //       onAdFailedToLoad: (error) {
  //         log('❌ Interstitial failed to load: $error');
  //         _goNext();
  //       },
  //       context: context,
  //     );
  //   } else {
  //     log('splash disable from remote config');
  //     _goNext();
  //   }
  // }

  // iosInterAd(BuildContext context) {
  //   if (RemoteConfigService().inter_ad_for_IOS) {
  //     log('enabled ad splash intersitial from remote config ');
  //     AdManager.loadInterstitialAd(
  //       onAdLoaded: () {
  //         if (_navigated) {
  //           // agar already navigate ho gaya to ad ignore kar do
  //           AdManager.disposeInterstitial();
  //           return;
  //         }
  //         log('✅ Interstitial Loaded in Splash');
  //         _showAd();
  //       },
  //       onAdFailedToLoad: (error) {
  //         log('❌ Interstitial failed to load: $error');
  //         _goNext();
  //       },
  //       context: context,
  //     );
  //   } else {
  //     log('splash disable from remote config');
  //     _goNext();
  //   }
  // }

  void _showAd() {
    AdManager.showInterstitialAd(
      onDismiss: () async {
        log('🚪 Ad dismissed → next screen');

        _goNext();
      },
      onAddFailedToShow: () async {
        log('❌ Failed to show Ad → next screen');

        _goNext();
      },
    );
  }

  bool islogin = false;
  void _goNext() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (_navigated) return;
    _navigated = true;
    await trackCompletedResult();
    _splashTimer?.cancel();
    AdManager.disposeInterstitial(); // ✅ ensure ad cancel/dispose
    // ✅ Give 10 free queries first time
    if (!Get.find<ProScreenController>().isUserPro.value) {
      QueryManager.downgradeToFreeIfNeeded();
      // log('user is not pro from splash');
      // if (!sp.containsKey(kFreeQueriesKey)) {
      //   await sp.setInt(kFreeQueriesKey, kInitialFreeQueries);
      //   log('🎁 Assigned $kInitialFreeQueries free queries to new user');
      // } else {
      //   log('user already using free queries ');
      // }
    } else {
      log('user is pro from splash');
    }

    bool islogin = sp.getBool('isInitialized') ?? false;
    if (islogin) {
      Get.off(() => BottomBarView());
    } else {
      Get.off(() => LanguageSelectionScreen());
    }
  }

  @override
  void onClose() {
    _splashTimer?.cancel();
    AdManager.disposeInterstitial(); // ✅ cleanup on destroy
    super.onClose();
  }
}
