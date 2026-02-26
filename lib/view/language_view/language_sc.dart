import 'dart:developer';
import 'dart:io';

import 'package:ai_story_writer/constant/app_Strings.dart';
import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/services/admanage_service.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view/onboarding_view/onboarding_view.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  bool isFromSetting = false;
  LanguageSelectionScreen({super.key, this.isFromSetting = false});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  int selectedIndex = 3;

  // Language codes mapping - SIRF KEYS rakho, .tr UI mein use karo
  final List<Map<String, String>> languages = [
    {
      "flag": AppImages.France,
      "nameKey": AppKeys.french, // .tr hata diya
      "native": "(française)",
      "code": "fr",
    },
    {
      "flag": AppImages.German,
      "nameKey": AppKeys.german,
      "native": "(Deutsch)",
      "code": "de",
    },
    {
      "flag": AppImages.Russia,
      "nameKey": AppKeys.russian,
      "native": "(русский)",
      "code": "ru",
    },
    {
      "flag": AppImages.english,
      "nameKey": AppKeys.english,
      "native": "(Default)",
      "code": "en",
    },
    {
      "flag": AppImages.China,
      "nameKey": AppKeys.chinese,
      "native": "(中国人)",
      "code": "zh",
    },
    // {
    //   "flag": AppImages.southKoria,
    //   "nameKey": AppKeys.korean,
    //   "native": "(한국인)",
    //   "code": "ko",
    // },
    {
      "flag": AppImages.Spain,
      "nameKey": AppKeys.spanish,
      "native": "(Española)",
      "code": "es",
    },
    {
      "flag": AppImages.Portugese,
      "nameKey": AppKeys.portuguese,
      "native": "(Português)",
      "code": "pt",
    },
    {
      "flag": AppImages.Arabic,
      "nameKey": AppKeys.arabic,
      "native": "(العربية)",
      "code": "ar",
    },
    // {
    //   "flag": AppImages.Hindi,
    //   "nameKey": AppKeys.hindi,
    //   "native": "(हिन्दी)",
    //   "code": "hi",
    // },
    // {
    //   "flag": AppImages.Japanese,
    //   "nameKey": AppKeys.japanese,
    //   "native": "(日本語)",
    //   "code": "ja",
    // },
    {
      "flag": AppImages.Indonesian,
      "nameKey": AppKeys.indonesian,
      "native": "(Bahasa)",
      "code": "id",
    },
    // {
    //   "flag": AppImages.turkish,
    //   "nameKey": AppKeys.turkish,
    //   "native": "(Türkçe)",
    //   "code": "tr",
    // },
  ];

  @override
  void initState() {
    super.initState();
    // Sorting se pehle translation karo
    loadSavedLanguage();
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
    showCrossButtonDelay();
  }

  bool isBannerAdLoaded = false;

  // ✅ Har controller ki apni banner ad
  BannerAd? bannerAd;
  void _loadBannerAd() {
    bannerAd = AdManager.loadBannerAd(
      context: Get.context!,
      onAdLoaded: (ad) {
        bannerAd = ad;
        isBannerAdLoaded = true;
        debugPrint("✅ Home Banner Loaded");
      },
      onAdFailedToLoad: (error) {
        isBannerAdLoaded = false;
        debugPrint("❌ Home Banner Failed: $error");
      },
    );
  }

  // Load saved language
  Future<void> loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('language_code');
    if (savedLanguage != null) {
      int index = languages.indexWhere((lang) => lang['code'] == savedLanguage);
      if (index != -1) {
        setState(() {
          selectedIndex = index;
        });
      }
    }
  }

  // Save and change language
  Future<void> changeLanguage(int index) async {
    String languageCode = languages[index]['code']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);

    // Change locale
    await Get.updateLocale(Locale(languageCode));

    setState(() {
      selectedIndex = index;
    });
  }

  bool isDelayOff = false;

  showCrossButtonDelay() async {
    Future.delayed(Duration(seconds: 2)).then((s) {
      isDelayOff = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.scaffoldbgColor,
      bottomNavigationBar: isBannerAdLoaded
          ? SafeArea(
              child: Container(
                height: 60,
                width: double.infinity,
                // color: Color(0xff2A2A2E),
                child: Center(child: AdManager.getBannerWidget(bannerAd)),
              ),
            )
          : SizedBox(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppKeys.lblChooseLanguage.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  isDelayOff
                      ? GestureDetector(
                          onTap: () async {
                            if (widget.isFromSetting) {
                              await changeLanguage(selectedIndex);
                              Get.back();
                            } else {
                              if (selectedIndex >= 0) {
                                await changeLanguage(selectedIndex);
                                Get.to(() => OnboardingScreen());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please choose a language'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Appcolor.themeColor,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                                weight: 18,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: languages.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () async {
                      await changeLanguage(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Appcolor.themeColor.withOpacity(0.15)
                            : Appcolor.tileBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: Appcolor.themeColor, width: 2)
                            : null,
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          languages[index]["flag"]!,
                          height: 30,
                        ),
                        title: Row(
                          children: [
                            Text(
                              languages[index]["nameKey"]!
                                  .tr, // Yahan .tr use karo
                              style: TextStyle(
                                fontSize: SizeConfig.sp(14),
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              " ${languages[index]["native"]!.tr}", // Yahan .tr use karo
                              style: TextStyle(
                                fontSize: SizeConfig.sp(14),
                                color: isSelected
                                    ? Colors.white
                                    : Color(0xffB4B4B4),
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Obx(
      //   () =>
      //       Get.find<ProScreenController>().isUserPro.value
      //           ? SizedBox.shrink()
      //           : _isLoaded && _nativeAd != null
      //           ? RemoteConfigService().all_nativeAd_show
      //               ? Container(
      //                 margin: const EdgeInsets.symmetric(vertical: 8),
      //                 height: 120,
      //                 child: AdWidget(ad: _nativeAd!),
      //               )
      //               : SizedBox.shrink()
      //           : SizedBox.shrink(),
      // ),
    );
  }
}
