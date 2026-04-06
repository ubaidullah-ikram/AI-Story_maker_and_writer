import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/services/ad_counter_services.dart';
import 'package:ai_story_writer/services/admanage_service.dart';
import 'package:ai_story_writer/services/gemini_optimizer_service.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view/api_request_%20controller/api_request_controller.dart';
import 'package:ai_story_writer/view/loading_sc/loading_Sc.dart';
import 'package:ai_story_writer/view/pro_screen/pro_secreen.dart';
import 'package:ai_story_writer/view/result_view/result_sc.dart';
import 'package:ai_story_writer/view_model/input_controller/input_controller.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryGeneratorInputScreen extends StatefulWidget {
  String title;
  StoryGeneratorInputScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<StoryGeneratorInputScreen> createState() =>
      _StoryGeneratorInputScreenState();
}

class _StoryGeneratorInputScreenState extends State<StoryGeneratorInputScreen> {
  String selectedLength = 'Short';
  int selectedLengthIndex = 0;
  double creativity = 0.5;
  String selectedGenre = 'Fantasy';
  String selectedStyle = 'Standard';

  var apiController = Get.find<GeminiApiServiceController>();
  final List<String> genres = [
    'Fantasy',
    'Mystery',
    'Thriller',
    'Horror',
    'Sci-Fi',
    'Romance',
    'Comedy',
    'Kids',
    'Drama',
    'Adventure',
  ];
  final List<String> styles = [
    'Standard',
    'Imaginative',
    'Innovative',
    'Inspired',
  ];

  // loadInterAd() {
  //   AdManager.loadInterstitialAd(
  //     onAdLoaded: () {
  //       log('ad is loaded');
  //       // agar already navigate ho gaya to ad ignore kar do
  //       // AdManager.disposeInterstitial();
  //     },
  //     onAdFailedToLoad: (error) {},
  //     context: context,
  //   );
  // }

  // Updated _showAd() method
  void _showAd() {
    AdManager.showInterstitialAd(
      onDismiss: () {
        _navigateToLoadingScreen();
        log('✅ Ad dismissed → navigating to next screen');
      },
      onAddFailedToShow: () {
        _navigateToLoadingScreen();
        log('❌ Failed to show Ad → next screen');
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    apiController.userInputController.clear();
    // if (!Get.find<ProScreenController>().isUserPro.value) {
    //   if (Platform.isIOS) {
    //     if (RemoteConfigService().inter_ad_for_IOS) {
    //       loadInterAd();
    //     }
    //   } else {
    //     if (RemoteConfigService().intersitial_ads_for_andiod) {
    //       loadInterAd();
    //     }
    //   }
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // AdManager.disposeInterstitial();
  }

  var inputScreenController = Get.put(InputController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.scaffoldbgColor,

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Text(
                        widget.title.tr,
                        style: TextStyle(
                          fontFamily: AppFonts.inter,
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Obx(
                        //   () => inputScreenController.isBannerAdLoaded.value
                        //       ? Container(
                        //           height: 60,
                        //           width: double.infinity,
                        //           // color: Color(0xff2A2A2E),
                        //           child: Center(
                        //             child: AdManager.getBannerWidget(
                        //               inputScreenController.bannerAd,
                        //             ),
                        //           ),
                        //         )
                        //       : SizedBox(),
                        // ),
                        const SizedBox(height: 8),
                        _buildLengthSelector(),
                        const SizedBox(height: 20),
                        _buildTextInput(),
                        const SizedBox(height: 24),
                        Text(
                          'Set Creativity'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.inter,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildCreativitySlider(),
                        const SizedBox(height: 24),
                        _buildGenreSelector(),
                        const SizedBox(height: 24),
                        _buildStyleSelector(),
                        const SizedBox(height: 32),
                        _buildGenerateButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Blur effect
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
      ),
    );
  }

  Widget _buildLengthSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            _buildLengthOption('Short', 0),
            _buildLengthOption('Medium', 1),
            _buildLengthOption('Long', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildLengthOption(String length, int index) {
    bool isSelected = selectedLength == length;
    bool isProFeature = length != 'Short';
    bool isUserPro = Get.find<ProScreenController>().isUserPro.value;
    bool isLocked = isProFeature && !isUserPro;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // if (isLocked) {
          //   Fluttertoast.showToast(
          //     msg: "Please upgrade to Pro to use $length stories".tr,
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     backgroundColor: Colors.orange,
          //     textColor: Colors.white,
          //     fontSize: 16.0,
          //   );
          //   return;
          // }
          selectedLengthIndex = index;
          selectedLength = length;
          setState(() {
            log(
              'the selected lenght of story generator input is ${selectedLength}',
            );
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Appcolor.themeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            // opacity: isLocked ? 0.5 : 1.0,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                length.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: AppFonts.inter,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isLocked)
                Positioned(
                  right: index == 1 ? 4 : 10,
                  top: 4,
                  child: Icon(Icons.lock, color: Colors.white, size: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      height: 280,
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: TextField(
        onTapUpOutside: (event) {
          FocusManager.instance.primaryFocus!.unfocus();
          // Get.back();
        },
        controller: apiController.userInputController,
        maxLines: null,
        maxLength: GeminiOptimizerService.maxTopicLength,
        expands: true,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.inter,
        ),
        decoration: InputDecoration(
          hintText: 'Describe your topic...'.tr,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildCreativitySlider() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              activeTrackColor: const Color(0xFF7C3AED),
              inactiveTrackColor: Colors.grey.shade700,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12,
                elevation: 4,
              ),
              overlayColor: Appcolor.themeColor,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: creativity,
              onChanged: (value) {
                setState(() {
                  creativity = value;
                });
              },
              min: 0,
              max: 1,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Standard'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppFonts.inter,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Complex'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  'Creative'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Genre'.tr,
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.inter,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: genres.map((genre) {
              bool isSelected = selectedGenre == genre;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGenre = genre;
                    });
                  },
                  child: Container(
                    height: SizeConfig.h(36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      // vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Appcolor.themeColor
                          : Appcolor.tileBackground,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xff34343C), width: 1),
                    ),
                    child: Center(
                      child: Text(
                        genre.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.sp(12),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Style'.tr,
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.inter,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: styles.map((style) {
              bool isSelected = selectedStyle == style;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStyle = style;
                    });
                  },
                  child: Container(
                    height: SizeConfig.h(36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      // vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Appcolor.themeColor
                          : Appcolor.tileBackground,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xff34343C), width: 1),
                    ),
                    child: Center(
                      child: Text(
                        style.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.sp(12),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return GestureDetector(
      onTap: () async {
        if (apiController.userInputController.text.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please enter a topic".tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        // Client-side validation to avoid wasting API tokens
        final validationError = GeminiOptimizerService.validateInput(
          apiController.userInputController.text,
        );
        if (validationError != null) {
          Fluttertoast.showToast(
            msg: validationError.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        if (!Get.find<ProScreenController>().isUserPro.value &&
            selectedLengthIndex != 0) {
          Get.to(() => ProScreen());
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();

        _navigateToLoadingScreen();
        // if (!Get.find<ProScreenController>().isUserPro.value) {
        //   _showAd();
        // } else {
        //   _navigateToLoadingScreen();
        // }
      },
      child: Container(
        height: SizeConfig.h(50),
        decoration: BoxDecoration(
          color: Appcolor.themeColor,
          borderRadius: BorderRadius.circular(50),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.star, height: 20, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Generate'.tr,
              style: TextStyle(
                fontFamily: AppFonts.inter,
                color: Colors.white,
                fontSize: SizeConfig.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigation helper method
  void _navigateToLoadingScreen() {
    Get.to(
      () => AILoadingScreen(
        toolName: "Story Generator",
        prompt: generateStoryPrompt(),
      ),
    );
  }

  String generateStoryPrompt() {
    final userInput = GeminiOptimizerService.trimInput(
      apiController.userInputController.text,
    );
    String prompt =
        '''Write a ${selectedLength} ${selectedGenre} story in ${selectedStyle} style (creativity: ${creativity.toStringAsFixed(1)}).

Topic: $userInput

Rules:
- The topic MUST be the main character/focus of the story
- Write FROM the perspective of or CENTERED ON the topic
- Clear paragraphs with line breaks
- Simple, engaging wording

Structure:
1. **TITLE**: Catchy title
2. **STORY**: Main narrative (${selectedLength == 'Short'
            ? '3-4 paragraphs'
            : selectedLength == 'Medium'
            ? '5-7 paragraphs'
            : '8-12 paragraphs'})
3. **CHARACTER LESSON**: What the main character learns
4. **MORAL**: Key lesson (1-2 sentences)
''';

    return prompt;
  }
}
