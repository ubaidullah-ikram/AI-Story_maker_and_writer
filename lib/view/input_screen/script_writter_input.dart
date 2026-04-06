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
import 'package:ai_story_writer/view/input_screen/widgets/custom_dpdown_for_script.dart';
import 'package:ai_story_writer/view/input_screen/widgets/custom_dropdown_for_essay.dart';
import 'package:ai_story_writer/view/loading_sc/loading_Sc.dart';
import 'package:ai_story_writer/view/result_view/result_sc.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ScriptWritterInput extends StatefulWidget {
  ScriptWritterInput({Key? key}) : super(key: key);

  @override
  State<ScriptWritterInput> createState() => _ScriptWritterInputState();
}

class _ScriptWritterInputState extends State<ScriptWritterInput> {
  String selectedLenght = 'Short (200-500 words)';

  final List<String> essayLenghtList = [
    'Short (200-500 words)',
    'Medium (500-1000 words)',
    'Large (1000+ words)',
  ];

  var apiController = Get.find<GeminiApiServiceController>();
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

  // Navigation helper method
  void _navigateToLoadingScreen() {
    Get.to(
      () => AILoadingScreen(
        toolName: "Script Writer",
        prompt: generateScriptPrompt(
          topic: apiController.userInputController.text,
          scriptFormat: apiController.selectedScriptTone.value.toString(),
          scriptGenre: apiController.selectedScriptType2.value.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.scaffoldbgColor,
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF1A1625),
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () {},
      //   ),
      //   title: const Text(
      //     'Result',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
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
                        'Script Generator'.tr,
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
                        const SizedBox(height: 8),

                        _buildTextInput(),
                        const SizedBox(height: 24),

                        CustomDpdownForScript(),
                        const SizedBox(height: 24),

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
        onTapUpOutside: (event) {
          FocusManager.instance.primaryFocus!.unfocus();
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

        _navigateToLoadingScreen();
        // if (!Get.find<ProScreenController>().isUserPro.value) {
        //   _showAd();
        // } else {
        //   _navigateToLoadingScreen();
        // }

        // Get.to(() => ResultScView());
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

  String generateScriptPrompt({
    required String topic,
    required String scriptFormat,
    required String scriptGenre,
  }) {
    final trimmedTopic = GeminiOptimizerService.trimInput(topic);
    String prompt =
        '''Write a production-ready $scriptFormat script in the $scriptGenre genre.

Topic: $trimmedTopic

Requirements:
- Start with a powerful hook in the first 10 seconds
- Maintain consistent $scriptGenre tone
- Include scene descriptions and visual cues
- Natural, engaging dialogue
- Add [VISUAL NOTES], (AUDIO CUES), and *emotion/action* descriptions
- Strong ending with impact
- Proper script formatting with timing/duration notes
- Camera angles for visual formats
- Scene transitions

${_getFormatGuidelinesCompact(scriptFormat)}
${_getGenreGuidelinesCompact(scriptGenre)}
''';

    return prompt;
  }

  String _getFormatGuidelinesCompact(String format) {
    switch (format) {
      case 'YouTube Video':
        return 'Format: HOOK(0-10s) → INTRO(10-45s) → MAIN CONTENT(3-4 sections with [B-ROLL]) → OUTRO with CTA. Duration: 8-12min.';
      case 'Short Film':
        return 'Format: Standard screenplay (INT./EXT. LOCATION - TIME). Include character emotions, camera angles, transitions. Duration: 5-15min.';
      case 'Advertisement':
        return 'Format: OPENING hook(0-5s) → BODY solution(5-45s) → CLOSING CTA(45-60s). Include V.O., [PRODUCT SHOTS], tagline. Duration: 30-60s.';
      case 'Podcast':
        return 'Format: COLD OPEN(0-1min) → INTRO(1-2min) → MAIN SEGMENTS(2-3 segments) → OUTRO. Include [MUSIC] and [SOUND EFFECTS]. Duration: 15-30min.';
      case 'Reel':
        return 'Format: HOOK(0-3s) → CONTENT(3-50s) → CTA(50-60s). Fast-paced, [TEXT OVERLAYS], vertical 9:16. Duration: 15-60s.';
      case 'Tiktok Video':
        return 'Format: HOOK(0-1s) → BUILD-UP(1-45s) → PAYOFF(45-60s). Viral-focused with [TRENDING SOUND] and hashtags. Duration: 15-60s.';
      case 'Movie':
        return 'Format: Professional screenplay with scene headings, cinematic descriptions, character blocking, lighting notes. Duration: 3-5min scene.';
      case 'Film Script':
        return 'Format: INT./EXT. LOCATION - DAY/NIGHT. Character names CAPS, parentheticals, present tense action, camera directions, transitions.';
      case 'Stage Play':
        return 'Format: ACT/SCENE divisions, set descriptions, [stage directions], UPSTAGE/DOWNSTAGE, lighting/sound cues, entrances/exits.';
      case 'Scene Breakdown':
        return 'Format: Scene number, INT/EXT, location, time, characters, props, wardrobe, VFX, stunts, extras, key dialogue, duration.';
      case 'Dialogue Only':
        return 'Format: Pure dialogue - CHARACTER NAME: "line" with (emotions) and [brief actions]. No scene descriptions or camera directions.';
      default:
        return 'Format: Clear beginning, middle, end with proper formatting for chosen medium.';
    }
  }

  String _getGenreGuidelinesCompact(String genre) {
    switch (genre) {
      case 'Comedy':
        return 'Genre tone: Setup-punchline structure, witty dialogue, physical comedy, [PAUSE FOR LAUGH] markers, callback jokes.';
      case 'Drama':
        return 'Genre tone: Emotional depth, character development, conflict/tension, meaningful dialogue, subtle performances.';
      case 'Horror':
        return 'Genre tone: Build suspense/dread, jump scare opportunities, [CREEPY SOUNDS], dark atmosphere, psychological elements.';
      case 'Action':
        return 'Genre tone: Fast-paced sequences, choreography descriptions, [SOUND EFFECTS], dynamic camera, adrenaline scenes.';
      case 'Romance':
        return 'Genre tone: Character chemistry, emotional vulnerability, tender moments, romantic tension, heartfelt dialogue.';
      case 'Motivational':
        return 'Genre tone: Inspiring message, relatable struggles, uplifting arc, powerful voiceover, empowering language.';
      case 'Mystery':
        return 'Genre tone: Intriguing setup, planted clues, red herrings, suspenseful pacing, plot twists, reveal moments.';
      case 'Fairy Tale':
        return 'Genre tone: Magical elements, good vs evil, moral lesson, whimsical descriptions, hero journey, happy ending.';
      case 'Thriller':
        return 'Genre tone: High stakes/urgency, constant tension, plot twists, race against time, edge-of-seat moments.';
      case 'Sci-Fi':
        return 'Genre tone: Futuristic technology, scientific concepts, world-building, innovative gadgets, thought-provoking themes.';
      case 'Kids':
        return 'Genre tone: Age-appropriate (5-12), simple language, fun/colorful, educational, positive messages, no scary content.';
      default:
        return 'Genre tone: Match $genre conventions consistently with appropriate pacing.';
    }
  }
}
