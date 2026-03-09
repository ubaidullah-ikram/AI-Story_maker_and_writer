import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/view/api_request_%20controller/api_request_controller.dart';
import 'package:ai_story_writer/view/loading_sc/loading_Sc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RewriteStoryInputScreen extends StatefulWidget {
  const RewriteStoryInputScreen({Key? key}) : super(key: key);

  @override
  State<RewriteStoryInputScreen> createState() =>
      _RewriteStoryInputScreenState();
}

class _RewriteStoryInputScreenState extends State<RewriteStoryInputScreen> {
  final TextEditingController storyController = TextEditingController();

  String selectedTone = 'Same';
  String selectedStyle = 'Improved';
  String selectedLength = 'Same';

  var apiController = Get.find<GeminiApiServiceController>();

  final List<String> tones = [
    'Same',
    'More Dramatic',
    'More Humorous',
    'More Emotional',
    'More Suspenseful',
    'Lighter',
  ];

  final List<String> styles = [
    'Improved',
    'Simplified',
    'More Descriptive',
    'More Dialogue',
    'More Action',
    'Literary',
  ];

  final List<String> lengths = ['Same', 'Shorter', 'Longer', 'Much Longer'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  void _navigateToLoadingScreen() {
    Get.to(
      () => AILoadingScreen(
        toolName: "Rewrite Story",
        prompt: generateRewritePrompt(),
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
                        'Rewrite Story'.tr,
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
                        _buildSectionTitle('Paste Your Story'.tr),
                        const SizedBox(height: 12),
                        _buildStoryInput(),
                        const SizedBox(height: 24),
                        _buildToneSelector(),
                        const SizedBox(height: 24),
                        _buildStyleSelector(),
                        const SizedBox(height: 24),
                        _buildLengthSelector(),
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

  Widget _buildStoryInput() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: TextField(
        onTapUpOutside: (event) {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        controller: storyController,
        maxLines: null,
        expands: true,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.inter,
        ),
        decoration: InputDecoration(
          hintText: 'Paste your story here to rewrite...'.tr,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Select Tone'.tr),
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

  Widget _buildStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Rewrite Style'.tr),
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

  Widget _buildLengthSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Output Length'.tr),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: lengths.map((length) {
              bool isSelected = selectedLength == length;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLength = length;
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
                        length.tr,
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
        if (storyController.text.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please paste your story".tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        if (storyController.text.length < 50) {
          Fluttertoast.showToast(
            msg: "Story is too short. Please provide more content.".tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();

        // Set the title for history
        apiController.userInputController.text = "Rewritten Story";
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
              'Rewrite Story'.tr,
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

  String generateRewritePrompt() {
    String lengthInstruction = '';
    switch (selectedLength) {
      case 'Shorter':
        lengthInstruction =
            'Make the rewritten story 30-40% shorter while keeping the essence.';
        break;
      case 'Longer':
        lengthInstruction =
            'Expand the story by 40-50% with more details and descriptions.';
        break;
      case 'Much Longer':
        lengthInstruction =
            'Significantly expand the story by 80-100% with rich details, more scenes, and deeper character development.';
        break;
      default:
        lengthInstruction = 'Keep the length approximately the same.';
    }

    String styleInstruction = '';
    switch (selectedStyle) {
      case 'Simplified':
        styleInstruction =
            'Use simpler vocabulary and shorter sentences for easier reading.';
        break;
      case 'More Descriptive':
        styleInstruction =
            'Add vivid descriptions of settings, emotions, and sensory details.';
        break;
      case 'More Dialogue':
        styleInstruction = 'Increase character dialogue and conversations.';
        break;
      case 'More Action':
        styleInstruction = 'Add more action sequences and dynamic scenes.';
        break;
      case 'Literary':
        styleInstruction =
            'Use sophisticated literary techniques, metaphors, and elegant prose.';
        break;
      default:
        styleInstruction =
            'Improve the writing quality while maintaining the original style.';
    }

    String toneInstruction = '';
    switch (selectedTone) {
      case 'More Dramatic':
        toneInstruction =
            'Make the tone more dramatic with heightened emotions and tension.';
        break;
      case 'More Humorous':
        toneInstruction = 'Add humor, wit, and lighter moments.';
        break;
      case 'More Emotional':
        toneInstruction = 'Deepen the emotional impact and character feelings.';
        break;
      case 'More Suspenseful':
        toneInstruction = 'Build suspense and create tension throughout.';
        break;
      case 'Lighter':
        toneInstruction = 'Make the tone lighter and more optimistic.';
        break;
      default:
        toneInstruction = 'Maintain the original tone.';
    }

    String prompt =
        '''
CRITICAL INSTRUCTION - READ FIRST:
1. Before rewriting, silently verify the story is valid content
2. If content is gibberish/invalid → ONLY respond with: "INVALID_INPUT: Please provide a valid story to rewrite."
3. If content is VALID → Go DIRECTLY to rewriting without any preamble.

---

You are an expert story editor and rewriter. Rewrite the following story with these specifications:

REWRITE INSTRUCTIONS:
- Tone: $toneInstruction
- Style: $styleInstruction
- Length: $lengthInstruction

ORIGINAL STORY:
"""
${storyController.text}
"""

REQUIREMENTS:
1. Maintain the core plot, characters, and setting
2. Improve grammar, flow, and readability
3. Apply the specified tone, style, and length changes
4. Make the story more engaging and polished
5. Keep the original theme and message intact

OUTPUT FORMAT:

## ✨ REWRITTEN STORY

[Your beautifully rewritten story here]

---

### 📝 CHANGES MADE
- Brief summary of improvements and changes applied
- What was enhanced
- Overall quality improvements

Make the rewritten story captivating and professionally written!
''';

    return prompt;
  }
}
