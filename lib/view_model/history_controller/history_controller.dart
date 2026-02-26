import 'dart:io';

import 'package:ai_story_writer/services/admanage_service.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HistoryController extends GetxController {
  final isBannerAdLoaded = false.obs;
  BannerAd? bannerAd; // ✅ Settings ki apni banner ad

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
        debugPrint("✅ history Banner Loaded");
      },
      onAdFailedToLoad: (error) {
        isBannerAdLoaded.value = false;
        debugPrint("❌ history Banner Failed: $error");
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
