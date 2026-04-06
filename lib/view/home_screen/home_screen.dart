import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/custom_rating.dart';
import 'package:ai_story_writer/services/ad_counter_services.dart';
import 'package:ai_story_writer/services/admanage_service.dart';
import 'package:ai_story_writer/services/check_internet.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view/api_request_%20controller/api_request_controller.dart';
import 'package:ai_story_writer/view/home_screen/widgets/guidance_alert.dart';
import 'package:ai_story_writer/view/input_screen/input_sc_essay_writter.dart';
import 'package:ai_story_writer/view/input_screen/input_screen_story_gen.dart';
import 'package:ai_story_writer/view/input_screen/script_writter_input.dart';
import 'package:ai_story_writer/view/input_screen/character_story_input.dart';
import 'package:ai_story_writer/view/input_screen/rewrite_story_input.dart';
import 'package:ai_story_writer/view/input_screen/title_generator_input.dart';
import 'package:ai_story_writer/view/input_screen/blog_writer_input.dart';
import 'package:ai_story_writer/view/input_screen/youtube_script_input.dart';
import 'package:ai_story_writer/view/pro_screen/pro_secreen.dart';
import 'package:ai_story_writer/view/result_view/dmy.dart';
import 'package:ai_story_writer/view_model/home_view_model/home_view_model.dart';
import 'package:ai_story_writer/view_model/input_controller/input_controller.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var apiController = Get.put(GeminiApiServiceController());
  var inputScreenController = Get.put(InputController());
  var homeController = Get.find<HomeController>();

  // Ad loading timer ko track karne ke liye
  Timer? _adLoadingTimer;
  bool _isAdDialogShowing = false;

  @override
  void initState() {
    super.initState();
    getAppInfo();
    secondOpen();
  }

  Future<void> _launchURL(String urlN) async {
    final Uri url = Uri.parse(urlN); // jis URL par jana hy
    try {
      await launchUrl(
        url,
        // mode: LaunchMode.externalApplication, // external browser khulega
      );
    } catch (e) {}
  }

  Future<void> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    if (int.parse(buildNumber) < RemoteConfigService().force_update_version) {
      log('update require');
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Update Required"),
            content: Text("Please update app to continue"),
            actions: [
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    _launchURL(
                      'https://play.google.com/store/apps/details?id=com.ai.story.generator.novel.script.writer.maker',
                    );
                  } else {
                    _launchURL('https://apps.apple.com/app/id6755809339');
                  }
                  // launchUrl(Uri.parse(appStoreLink));
                },
                child: Text("Update"),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      log('not require');
    }
    print("Version: $version");
    print("Build Number: $buildNumber");
  }

  var appOpenCountKey = "second_app_opened";
  Future<void> secondOpen() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(appOpenCountKey) ?? 0;
    log('count  $count');
    if (count == 2) {
      var isratingShowedOnce = prefs.getString('ratingShowedOnce') ?? 'no';
      log('isratingShowedOnce  $isratingShowedOnce');
      if (isratingShowedOnce == 'no') {
        await prefs.setString('ratingShowedOnce', 'yes');
        await showRatingPrompt();
      }
    }
  }

  Future<void> showRatingPrompt() async {
    await showCustomRatingDialog();
    // final InAppReview inAppReview = InAppReview.instance;

    // if (await inAppReview.isAvailable()) {
    //   inAppReview.requestReview(); // Native App Store / Play Store popup
    // } else {
    //   inAppReview.openStoreListing(
    //     appStoreId: 'YOUR_IOS_APP_ID', // iOS only
    //     microsoftStoreId: null,
    //   );
    // }
  }

  showAdLoadingDialog(BuildContext context, int index) {
    _isAdDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Appcolor.tileBackground,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Text(
                'Ad loading please wait..'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );

    // 5 second ka timer - agar ad load nahi hua to proceed karo
    _adLoadingTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isAdDialogShowing) {
        Navigator.of(context).pop();
        _isAdDialogShowing = false;

        // Ad request ko puri tarah cancel karo
        AdManager.cancelAdRequest();
        log('⏱️ Ad loading timeout - Ad request cancelled');

        _navigateToTool(index);
      }
    });
  }

  loadInterAd(int index) async {
    bool hasInternet = await InternetCheckService.hasInternetConnection();

    if (!hasInternet) {
      log('❌ No internet connection - skipping ad');
      _navigateToTool(index);
      return;
    }

    if (Get.find<ProScreenController>().isUserPro.value) {
      _navigateToTool(index);

      return;
    }
    if (Platform.isIOS) {
      if (!RemoteConfigService().inter_ad_for_IOS) {
        _navigateToTool(index);

        return;
      }
    } else {
      if (!RemoteConfigService().intersitial_ads_for_andiod) {
        _navigateToTool(index);

        return;
      }
    }
    showInterstitialIfNeeded(
      index == 0
          ? "story_gen_tool"
          : index == 1
          ? "essay_writer_tool"
          : index == 2
          ? "script_gen_tool"
          : index == 3
          ? "character_story_tool"
          : index == 4
          ? "rewrite_story_tool"
          : index == 5
          ? "title_gen_tool"
          : index == 6
          ? "blog_writer_tool"
          : "youtube_script_tool",
      index,
    );
  }

  void _navigateToTool(int index) {
    if (index == 0) {
      Get.to(() => StoryGeneratorInputScreen(title: "Story Generator"));
    } else if (index == 1) {
      Get.to(() => EssayWriterScreen());
    } else if (index == 2) {
      Get.to(() => ScriptWritterInput());
    } else if (index == 3) {
      Get.to(() => CharacterStoryInputScreen());
    } else if (index == 4) {
      Get.to(() => RewriteStoryInputScreen());
    } else if (index == 5) {
      Get.to(() => TitleGeneratorInputScreen());
    } else if (index == 6) {
      Get.to(() => BlogWriterInputScreen());
    } else if (index == 7) {
      Get.to(() => YouTubeScriptInputScreen());
    }
  }

  void _showAd(int index) {
    AdManager.showInterstitialAd(
      onDismiss: () async {
        _navigateToTool(index);
      },
      onAddFailedToShow: () async {
        _navigateToTool(index);
        log('❌ Failed to show Ad → next screen');
      },
    );
  }

  void showInterstitialIfNeeded(String moduleKey, int index) async {
    final prefs = await SharedPreferences.getInstance();
    int clickCount = prefs.getInt(moduleKey) ?? 0;
    clickCount++;
    prefs.setInt(moduleKey, clickCount);

    if (clickCount == 1 || (clickCount - 1) % 3 == 0) {
      await showAdLoadingDialog(context, index);

      AdManager.loadInterstitialAd(
        onAdLoaded: () {
          log('✅ Ad loaded successfully');

          // Timer cancel karo kyunki ad load ho gya
          _adLoadingTimer?.cancel();

          if (mounted && _isAdDialogShowing) {
            Navigator.of(context).pop();
            _isAdDialogShowing = false;
            _showAd(index);
          }
        },
        onAdFailedToLoad: (error) {
          log('❌ Failed to load ad: $error');

          // Timer cancel karo
          _adLoadingTimer?.cancel();

          if (mounted && _isAdDialogShowing) {
            Navigator.of(context).pop();
            _isAdDialogShowing = false;
          }

          _navigateToTool(index);
        },
        context: context,
      );
    } else {
      _navigateToTool(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AI Story Generator'.tr,
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Obx(
                      () => Get.find<ProScreenController>().isUserPro.value
                          ? SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                Get.to(() => ProScreen());
                              },
                              child: Container(
                                height: 30,
                                width: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: Center(
                                  child: Image.asset(
                                    AppImages.pro_icon,
                                    height: 14,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // TextButton(
                      //   onPressed: () async {
                      //   onPressed: () async {
                      //     final prefs = await SharedPreferences.getInstance();
                      //     showRatingPrompt();
                      //     // await prefs.setInt(appOpenCountKey, 0);
                      //   },
                      //   child: Text('datas'),
                      // ),
                      buildToolCard(
                        AppImages.story_writerIcon,
                        'Story Generator',
                        'Create original stories in seconds',
                        'Start Writing',
                        Color(0xffEE635B),
                        () {
                          loadInterAd(0);
                        },
                      ),
                      SizedBox(height: 16),
                      buildToolCard(
                        AppImages.essay_writer,
                        'Essay Writer',
                        'Academic writing made simple',
                        'Create Now',
                        Color(0xff9789BD),
                        () {
                          loadInterAd(1);
                        },
                      ),
                      SizedBox(height: 16),
                      buildToolCard(
                        AppImages.script_generator,
                        'Script Generator',
                        'Generate powerful scripts for any medium',
                        'Start Generating',
                        Color(0xffF973A4),
                        () {
                          loadInterAd(2);
                        },
                      ),
                      SizedBox(height: 16),

                      // New Tools - Module 1
                      buildToolCard(
                        AppImages.Your_own_character,
                        'Character Story',
                        'Create detailed character backstories',
                        'Create Character',
                        Color(0xff4ECDC4),
                        () {
                          loadInterAd(3);
                        },
                      ),
                      SizedBox(height: 16),
                      buildToolCard(
                        AppImages.Rewrite_story,
                        'Rewrite Story',
                        'Transform and improve your existing stories',
                        'Rewrite Now',
                        Color(0xffFF6B6B),
                        () {
                          loadInterAd(4);
                        },
                      ),
                      SizedBox(height: 16),
                      buildToolCard(
                        AppImages.title,
                        'Title Generator',
                        'Generate catchy titles for your stories',
                        'Generate Titles',
                        Color(0xffA855F7),
                        () {
                          loadInterAd(5);
                        },
                      ),
                      SizedBox(height: 16),

                      // Module 2: Blog Writer
                      buildToolCard(
                        AppImages.Blog_write,
                        'Blog Writer',
                        'SEO optimized articles with keywords',
                        'Write Blog',
                        Color(0xff10B981),
                        () {
                          loadInterAd(6);
                        },
                      ),
                      SizedBox(height: 16),

                      // Module 3: YouTube Script Generator
                      buildToolCard(
                        AppImages.Youtube_Script,
                        'YouTube Script',
                        'Create scripts for videos & reels',
                        'Create Script',
                        Color(0xffEF4444),
                        () {
                          loadInterAd(7);
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Banner Ad Placeholder
            Obx(
              () => homeController.isBannerAdLoaded.value
                  ? Container(
                      height: 60,
                      width: double.infinity,
                      // color: Color(0xff2A2A2E),
                      child: Center(
                        child: AdManager.getBannerWidget(
                          homeController.bannerAd,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),

        Positioned(
          top: -100,
          right: -10,
          child: IgnorePointer(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Appcolor.themeColor.withOpacity(0.20),
                      Appcolor.themeColor.withOpacity(0.01),
                    ],
                    radius: 0.7,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildToolCard(
    String image,
    String title,
    String subtitle,
    String btnText,
    Color btnColor,
    Function()? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xff1A1A1E),
          border: Border.all(color: Color(0xff34343C)),
        ),
        height: 150,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                leading: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Image.asset(image, height: 28)),
                ),
                title: Text(
                  title.tr,
                  style: TextStyle(
                    fontFamily: AppFonts.inter,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  subtitle.tr,
                  style: TextStyle(
                    fontFamily: AppFonts.inter,
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 42,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: btnColor,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Center(
                  child: Text(
                    btnText.tr,
                    style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
