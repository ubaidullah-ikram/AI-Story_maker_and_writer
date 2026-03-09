import 'dart:developer';
import 'dart:io';

import 'package:ai_story_writer/constant/app_Strings.dart';
import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/services/admanage_service.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view/bottom_navbar_view/bottom_navBar.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Story Magic".tr,
      "subtitle": 'Let AI bring your thoughts to a full story'.tr,
      "image": AppImages.onb1,
    },
    {
      "title": 'Smart Scripts'.tr,
      "subtitle": 'From concept to script—fast, easy, and creative'.tr,
      "image": AppImages.onb2,
    },
    {
      "title": 'Perfect Essays'.tr,
      "subtitle": 'Your tool for quick, high-quality essay writing'.tr,
      "image": AppImages.onb3,
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    // if (!Get.find<ProScreenController>().isUserPro.value) {
    //   if (Platform.isIOS) {
    //     if (RemoteConfigService().native_ad_for_IOS) {
    //       loadAd();
    //     }
    //   } else {
    //     if (RemoteConfigService().native_ad_for_android) {
    //       loadAd();
    //     }
    //   }
    // }

    // start fade-in as soon as screen loads
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void nextPage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (currentIndex < onboardingData.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      await sp.setBool("isInitialized", true);
      Get.offAll(() => BottomBarView());
      // TODO: Navigate to home screen after last page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.scaffoldbgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // color: Colors.amber,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: FadeTransition(
                    key: ValueKey<int>(currentIndex),
                    opacity: currentIndex == 0
                        ? _fadeAnimation
                        : kAlwaysCompleteAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        // vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: SizeConfig.h(20)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (currentIndex > 0) {
                                    setState(() {
                                      currentIndex--;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              Text(
                                onboardingData[currentIndex]["title"]!,
                                style: TextStyle(
                                  fontSize: SizeConfig.sp(22),
                                  fontFamily: AppFonts.inter,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.transparent,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              onboardingData[currentIndex]["subtitle"]!,
                              style: TextStyle(
                                fontSize: SizeConfig.sp(16),
                                fontFamily: AppFonts.inter,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: SizeConfig.h(10)),
                          Image.asset(
                            onboardingData[currentIndex]["image"]!,
                            height: Get.height * 0.64,
                            // fit: BoxFit.cover,
                            // width: double.infinity,
                          ),
                          // const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.h(10)),
              // Text('data'),
              // Spacer(),
              // Text('data'),
              // Indicator + Next
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: List.generate(
                          onboardingData.length,
                          (dotIndex) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            height: 10,
                            width: currentIndex == dotIndex ? 18 : 8,
                            decoration: BoxDecoration(
                              color: currentIndex == dotIndex
                                  ? Colors.white
                                  : Color(0xff27272D),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: nextPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            currentIndex == 2
                                ? "Get Started".tr
                                : AppKeys.btnNext.tr,
                            style: TextStyle(
                              fontFamily: AppFonts.inter,
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 20),
              // ads to show

              // Ad space
            ],
          ),
        ),
      ),
      // bottomSheet: _isLoaded && _nativeAd != null
      //     ? SafeArea(
      //         child: Container(
      //           color: Colors.black,
      //           height: 140,
      //           width: double.infinity,

      //           // child: Center(child: Text('Native ad area ',style: TextStyle(color: Colors.white),)),
      //           child: Center(child: AdWidget(ad: _nativeAd!)),
      //         ),
      //       )
      //     : SizedBox.shrink(),
    );
  }

  NativeAd? _nativeAd;
  bool _isLoaded = false;

  // void loadAd() {
  //   _nativeAd = NativeAd(
  //     adUnitId: AdIds.nativeAdId,
  //     listener: NativeAdListener(
  //       onAdLoaded: (ad) {
  //         log('native ad loaded.');
  //         setState(() {
  //           _isLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         log('native ad failedToLoad: $error');
  //         ad.dispose();
  //       },
  //       onAdClicked: (ad) {},
  //       onAdImpression: (ad) {},
  //       onAdClosed: (ad) {},
  //       onAdOpened: (ad) {},
  //       onAdWillDismissScreen: (ad) {},
  //       onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
  //     ),
  //     request: const AdRequest(),
  //     nativeTemplateStyle: NativeTemplateStyle(
  //       templateType: TemplateType.small,
  //     ),
  //   )..load();
  // }
}
