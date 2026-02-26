// import 'package:ai_story_writer/services/admanage_service.dart';
// import 'package:ai_story_writer/services/remote_config.dart';
// import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeController extends GetxController {
//   final bottomBarIndex = 0.obs;
//   final toolName = ''.obs;
//   final isBannerAdLoaded = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     if (RemoteConfigService().isAdOn &&
//         !Get.find<ProScreenController>().isUserPro.value) {

//     _loadBannerAd();
//     }
//   }

//   void _loadBannerAd() {
//     AdManager.loadBannerAd(
//       context: Get.context!,
//       onAdLoaded: () {
//         isBannerAdLoaded.value = true;
//         debugPrint("✅ Home Banner Loaded");
//       },
//       onAdFailedToLoad: (error) {
//         isBannerAdLoaded.value = false;
//         debugPrint("❌ Home Banner Failed: $error");
//       },
//     );
//   }

//   @override
//   void onClose() {
//     AdManager.disposeBanner();
//     super.onClose();
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:ai_story_writer/services/admanage_service.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeController extends GetxController {
  final bottomBarIndex = 0.obs;
  final toolName = ''.obs;
  final isBannerAdLoaded = false.obs;

  // ✅ Har controller ki apni banner ad
  BannerAd? bannerAd;

  @override
  void onInit() {
    super.onInit();
    if (!Get.find<ProScreenController>().isUserPro.value) {
      if (Platform.isIOS) {
        if (RemoteConfigService().banner_add_for_IOS) {
          _loadBannerAd();
        }
      } else {
        if (RemoteConfigService().banner_ad_for_android) {
          _loadBannerAd();
        }
      }
    }
  }

  void _loadBannerAd() {
    bannerAd = AdManager.loadBannerAd(
      context: Get.context!,
      onAdLoaded: (ad) {
        bannerAd = ad;
        isBannerAdLoaded.value = true;
        debugPrint("✅ Home Banner Loaded");
      },
      onAdFailedToLoad: (error) {
        isBannerAdLoaded.value = false;
        debugPrint("❌ Home Banner Failed: $error");
      },
    );
  }

  @override
  void onClose() {
    AdManager.disposeBanner(bannerAd);
    bannerAd = null;
    isBannerAdLoaded.value = false;
    super.onClose();
  }
}
