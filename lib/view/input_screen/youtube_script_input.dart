import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/services/gemini_optimizer_service.dart';
import 'package:ai_story_writer/view/api_request_%20controller/api_request_controller.dart';
import 'package:ai_story_writer/view/loading_sc/loading_Sc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class YouTubeScriptInputScreen extends StatefulWidget {
  const YouTubeScriptInputScreen({Key? key}) : super(key: key);

  @override
  State<YouTubeScriptInputScreen> createState() =>
      _YouTubeScriptInputScreenState();
}

class _YouTubeScriptInputScreenState extends State<YouTubeScriptInputScreen> {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController keyPointsController = TextEditingController();

  String selectedScriptType = 'Storytime';
  String selectedDuration = '5-10 min';
  String selectedTone = 'Engaging';
  bool includeHooks = true;
  bool includeCTA = true;
  bool includeTimestamps = true;

  var apiController = Get.find<GeminiApiServiceController>();

  final List<String> scriptTypes = [
    'Storytime',
    'Documentary',
    'Short Reel',
    'Motivational',
    'Educational',
    'Review',
    'Tutorial',
  ];

  final List<String> durations = [
    '< 1 min (Shorts)',
    '1-3 min',
    '5-10 min',
    '10-20 min',
    '20+ min',
  ];

  final List<String> tones = [
    'Engaging',
    'Professional',
    'Casual',
    'Energetic',
    'Calm',
    'Dramatic',
    'Funny',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    topicController.dispose();
    keyPointsController.dispose();
    super.dispose();
  }

  void _navigateToLoadingScreen() {
    Get.to(
      () => AILoadingScreen(
        toolName: "YouTube Script",
        prompt: generateYouTubeScriptPrompt(),
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
                        'YouTube Script'.tr,
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
                        _buildScriptTypeSelector(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Video Topic'.tr),
                        const SizedBox(height: 12),
                        _buildTopicInput(),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Key Points (Optional)'.tr),
                        const SizedBox(height: 12),
                        _buildKeyPointsInput(),
                        const SizedBox(height: 24),
                        _buildDurationSelector(),
                        const SizedBox(height: 24),
                        _buildToneSelector(),
                        const SizedBox(height: 24),
                        _buildOptionsSection(),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontFamily: AppFonts.inter,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildScriptTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Script Type'.tr),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: scriptTypes.map((type) {
              bool isSelected = selectedScriptType == type;
              IconData icon = _getScriptTypeIcon(type);
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedScriptType = type;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Appcolor.themeColor
                          : Appcolor.tileBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xff34343C), width: 1),
                    ),
                    child: Column(
                      children: [
                        Icon(icon, color: Colors.white, size: 24),
                        const SizedBox(height: 6),
                        Text(
                          type.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
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

  IconData _getScriptTypeIcon(String type) {
    switch (type) {
      case 'Storytime':
        return Icons.auto_stories;
      case 'Documentary':
        return Icons.movie;
      case 'Short Reel':
        return Icons.video_library;
      case 'Motivational':
        return Icons.emoji_events;
      case 'Educational':
        return Icons.school;
      case 'Review':
        return Icons.rate_review;
      case 'Tutorial':
        return Icons.play_lesson;
      default:
        return Icons.video_call;
    }
  }

  Widget _buildTopicInput() {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      height: 100,
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: TextField(
        onTapUpOutside: (event) {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        controller: topicController,
        maxLines: null,
        maxLength: GeminiOptimizerService.maxTopicLength,
        expands: true,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.inter,
        ),
        decoration: InputDecoration(
          hintText: 'What is your video about?'.tr,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildKeyPointsInput() {
    return Container(
      height: 80,
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: TextField(
        controller: keyPointsController,
        maxLines: null,
        maxLength: GeminiOptimizerService.maxKeywordsLength,
        expands: true,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.inter,
        ),
        decoration: InputDecoration(
          hintText: 'List key points to cover (optional)...'.tr,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Video Duration'.tr),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: durations.map((duration) {
              bool isSelected = selectedDuration == duration;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDuration = duration;
                    });
                  },
                  child: Container(
                    height: SizeConfig.h(36),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Appcolor.themeColor
                          : Appcolor.tileBackground,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xff34343C), width: 1),
                    ),
                    child: Center(
                      child: Text(
                        duration.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.sp(11),
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

  Widget _buildToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Script Tone'.tr),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tones.map((tone) {
              bool isSelected = selectedTone == tone;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTone = tone;
                    });
                  },
                  child: Container(
                    height: SizeConfig.h(36),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Appcolor.themeColor
                          : Appcolor.tileBackground,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xff34343C), width: 1),
                    ),
                    child: Center(
                      child: Text(
                        tone.tr,
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

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Script Options'.tr),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Appcolor.tileBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xff34343C), width: 1),
          ),
          child: Column(
            children: [
              _buildOptionSwitch('Include Hook/Intro'.tr, includeHooks, (
                value,
              ) {
                setState(() {
                  includeHooks = value;
                });
              }),
              Divider(color: Color(0xff34343C)),
              _buildOptionSwitch('Include Call-to-Action'.tr, includeCTA, (
                value,
              ) {
                setState(() {
                  includeCTA = value;
                });
              }),
              Divider(color: Color(0xff34343C)),
              _buildOptionSwitch('Include Timestamps'.tr, includeTimestamps, (
                value,
              ) {
                setState(() {
                  includeTimestamps = value;
                });
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionSwitch(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: AppFonts.inter,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Appcolor.themeColor,
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return GestureDetector(
      onTap: () async {
        if (topicController.text.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please enter a video topic".tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        final validationError = GeminiOptimizerService.validateInput(
          topicController.text,
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

        // Set the title for history
        apiController.userInputController.text = topicController.text;
        _navigateToLoadingScreen();
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
              'Generate Script'.tr,
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

  String generateYouTubeScriptPrompt() {
    final trimmedTopic = GeminiOptimizerService.trimInput(topicController.text);
    final trimmedKeyPoints = GeminiOptimizerService.trimInput(
      keyPointsController.text,
      maxLength: GeminiOptimizerService.maxKeywordsLength,
    );
    String scriptTypeHint = _getScriptTypeHint();

    String prompt =
        '''Write a complete $selectedScriptType YouTube script.

Topic: $trimmedTopic
Duration: $selectedDuration
Tone: $selectedTone
Key Points: ${trimmedKeyPoints.isNotEmpty ? trimmedKeyPoints : 'Cover the most important aspects'}

Style: $scriptTypeHint

Include:
- VIDEO METADATA: 3 title suggestions, description, 10-15 tags
${includeTimestamps ? '- TIMESTAMPS for each section' : ''}
${includeHooks ? '- HOOK (first 5-10 seconds) to grab attention' : ''}
- FULL SCRIPT: INTRO → MAIN CONTENT (3+ sections) → CONCLUSION
${includeCTA ? '- CALL TO ACTION (likes, subscribe, comment)' : ''}
- DELIVERY NOTES: tone, emphasis, pauses, B-roll suggestions
- SCRIPT INFO: word count, duration, speaking pace
''';

    return prompt;
  }

  String _getScriptTypeHint() {
    switch (selectedScriptType) {
      case 'Storytime':
        return 'First-person narrative with suspense, vivid descriptions, story arc, personal touches.';
      case 'Documentary':
        return 'Authoritative informative tone, facts/research, multiple perspectives, historical context.';
      case 'Short Reel':
        return 'Punchy concise content, strong 2-second hook, under 60 seconds, end with impact.';
      case 'Motivational':
        return 'Inspiring uplifting language, powerful quotes, emotional momentum, actionable advice.';
      case 'Educational':
        return 'Break complex topics simply, use analogies, logical structure, recap points.';
      case 'Review':
        return 'Honest balanced coverage, pros/cons, specific details, clear recommendation.';
      case 'Tutorial':
        return 'Step-by-step instructions, anticipate questions, tips/warnings, clear explanations.';
      default:
        return 'Engaging viewer-focused content with consistent pacing and clear structure.';
    }
  }
}
