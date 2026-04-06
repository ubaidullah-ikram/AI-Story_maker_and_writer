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
import 'package:ai_story_writer/view/input_screen/widgets/custom_dropdown_for_essay.dart';
import 'package:ai_story_writer/view/loading_sc/loading_Sc.dart';
import 'package:ai_story_writer/view/pro_screen/pro_secreen.dart';
import 'package:ai_story_writer/view/result_view/result_sc.dart';
import 'package:ai_story_writer/view_model/input_controller/input_controller.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EssayWriterScreen extends StatefulWidget {
  EssayWriterScreen({Key? key}) : super(key: key);

  @override
  State<EssayWriterScreen> createState() => _EssayWriterScreenState();
}

class _EssayWriterScreenState extends State<EssayWriterScreen> {
  String selectedLenght = 'Short (200-500 words)';
  int selectedLenghtIndex = 0;
  var apiController = Get.find<GeminiApiServiceController>();
  final List<String> essayLenghtList = [
    'Short (200-500 words)',
    'Medium (500-1000 words)',
    'Large (1000+ words)',
  ];

  var inputScreenController = Get.find<InputController>();
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

  loadInterAd() {
    AdManager.loadInterstitialAd(
      onAdLoaded: () {
        log('ad is loaded');
        // agar already navigate ho gaya to ad ignore kar do
        // AdManager.disposeInterstitial();
      },
      onAdFailedToLoad: (error) {},
      context: context,
    );
  }

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

  void _navigateToLoadingScreen() {
    Get.to(
      () => AILoadingScreen(
        toolName: 'Essay Writer'.tr,
        prompt: generateEssayPrompt(
          topic: apiController.userInputController.text.toString(),
          academicLevel: apiController.selectedAcademicLevel.value,
          paperType: apiController.selectedPaperType.value,
          essayLength: selectedLenght,
        ),
      ),
    );
  }

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
                        'Essay Writer'.tr,
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

                        _buildTextInput(),
                        const SizedBox(height: 24),

                        CustomDropdownScreen(),
                        const SizedBox(height: 24),

                        _buildGenreSelector(),
                        const SizedBox(height: 24),

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
        controller: apiController.userInputController,
        maxLines: null,
        maxLength: GeminiOptimizerService.maxTopicLength,
        expands: true,
        onTapUpOutside: (event) {
          FocusManager.instance.primaryFocus!.unfocus();
          // Get.back();
        },
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

  Widget _buildGenreSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Essay length'.tr,
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
            children: essayLenghtList.asMap().entries.map((entry) {
              int index = entry.key; // 0, 1, 2
              String genre = entry.value; // 'Short...', 'Medium...', 'Large...'

              bool isSelected = selectedLenght == genre;
              bool isProFeature = genre != 'Short (200-500 words)';
              bool isUserPro = Get.find<ProScreenController>().isUserPro.value;
              bool isLocked = isProFeature && !isUserPro;

              // log('Index: $index, Genre: $genre, IsLocked: $isLocked');

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    // if (isLocked) {
                    //   Fluttertoast.showToast(
                    //     msg: "Please upgrade to Pro to use $genre".tr,
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.BOTTOM,
                    //     backgroundColor: Colors.orange,
                    //     textColor: Colors.white,
                    //     fontSize: 16.0,
                    //   );
                    //   return;
                    // }
                    selectedLenghtIndex = index;
                    setState(() {
                      selectedLenght = genre;
                      log(
                        'Selected index: $index',
                      ); // Yeh print hoga tap karte waqt
                    });
                  },
                  child: Container(
                    height: SizeConfig.h(36),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Appcolor.themeColor
                          : Appcolor.tileBackground,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xff34343C), width: 1),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        if (isLocked)
                          Positioned(
                            right: 6,
                            top: 10,
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                      ],
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
        FocusManager.instance.primaryFocus?.unfocus();
        if (!Get.find<ProScreenController>().isUserPro.value &&
            selectedLenghtIndex != 0) {
          Get.to(() => ProScreen());
          return;
        }

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
  // Yeh function apne Essay Writer Screen mein update karo

  String generateEssayPrompt({
    required String topic,
    required String academicLevel,
    required String paperType,
    required String essayLength,
  }) {
    final trimmedTopic = GeminiOptimizerService.trimInput(topic);
    String prompt =
        '''Write a $paperType essay for $academicLevel level.

Topic: $trimmedTopic
Length: $essayLength

Requirements:
- Compelling introduction with clear thesis
- Well-organized body paragraphs with arguments and evidence
- Smooth transitions between paragraphs
- Conclusive ending reinforcing main points
- Appropriate vocabulary for $academicLevel level

Format: Introduction, Body Paragraphs, Conclusion with clear paragraph breaks.
''';

    return prompt;
  }
  //   String generateEssayPrompt({
  //     required String topic,
  //     required String academicLevel,
  //     required String paperType,
  //     required String essayLength,
  //   }) {
  //     String prompt =
  //         '''
  // You are an expert essay writer. Write a well-structured, high-quality essay based on the following parameters:

  // Topic: $topic

  // Academic Level: $academicLevel
  // Paper Type: $paperType
  // Essay Length: $essayLength

  // Requirements:
  // 1. Create a compelling introduction with a clear thesis statement
  // 2. Develop well-organized body paragraphs with strong arguments and evidence
  // 3. Include smooth transitions between paragraphs
  // 4. Write a conclusive ending that reinforces the main points
  // 5. Use appropriate vocabulary and tone for the $academicLevel level
  // 6. Follow the $paperType essay structure and conventions
  // 7. Ensure the essay length matches the requested word count range

  // Format the essay with:
  // - Clear paragraph breaks
  // - Proper structure (Introduction, Body Paragraphs, Conclusion)
  // - Academic writing style
  // - No plagiarism - original content only

  // Write the complete essay now:
  // ''';

  //     return prompt;
  //   }
}
