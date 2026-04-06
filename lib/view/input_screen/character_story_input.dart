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

class CharacterStoryInputScreen extends StatefulWidget {
  const CharacterStoryInputScreen({Key? key}) : super(key: key);

  @override
  State<CharacterStoryInputScreen> createState() =>
      _CharacterStoryInputScreenState();
}

class _CharacterStoryInputScreenState extends State<CharacterStoryInputScreen> {
  // Character Input Controllers
  final TextEditingController characterNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController personalityController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController additionalDetailsController =
      TextEditingController();

  String selectedGenre = 'Fantasy';
  String selectedOutputStyle = 'Detailed';

  var apiController = Get.find<GeminiApiServiceController>();

  final List<String> genres = [
    'Fantasy',
    'Sci-Fi',
    'Romance',
    'Horror',
    'Comedy',
    'Drama',
    'Adventure',
  ];

  final List<String> outputStyles = ['Detailed', 'Brief', 'Elaborate'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    characterNameController.dispose();
    ageController.dispose();
    personalityController.dispose();
    roleController.dispose();
    additionalDetailsController.dispose();
    super.dispose();
  }

  void _navigateToLoadingScreen() {
    Get.to(
      () => AILoadingScreen(
        toolName: "Character Story",
        prompt: generateCharacterPrompt(),
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
                        'Character Story'.tr,
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
                        _buildSectionTitle('Character Details'.tr),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: characterNameController,
                          hintText: 'Character Name'.tr,
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: ageController,
                          hintText: 'Age (e.g., 25, Young Adult, Ancient)'.tr,
                          icon: Icons.cake,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: personalityController,
                          hintText:
                              'Personality (e.g., brave, shy, cunning)'.tr,
                          icon: Icons.psychology,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: roleController,
                          hintText: 'Role (e.g., Hero, Villain, Mentor)'.tr,
                          icon: Icons.theater_comedy,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: additionalDetailsController,
                          hintText: 'Additional Details (optional)'.tr,
                          icon: Icons.info_outline,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        _buildGenreSelector(),
                        const SizedBox(height: 24),
                        _buildOutputStyleSelector(),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      // padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.inter,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          // prefixIcon: Icon(icon, color: Appcolor.themeColor),
        ),
      ),
    );
  }

  Widget _buildGenreSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Select Genre'.tr),
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
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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

  Widget _buildOutputStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Output Style'.tr),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: outputStyles.map((style) {
              bool isSelected = selectedOutputStyle == style;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOutputStyle = style;
                    });
                  },
                  child: Container(
                    height: SizeConfig.h(36),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
        if (characterNameController.text.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please enter character name".tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        if (roleController.text.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please enter character role".tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        final validationError = GeminiOptimizerService.validateInput(
          characterNameController.text,
          minLength: 2,
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
        apiController.userInputController.text = characterNameController.text;
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
              'Generate Character'.tr,
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

  String generateCharacterPrompt() {
    final backstoryLength = selectedOutputStyle == 'Brief'
        ? '2-3 paragraphs'
        : selectedOutputStyle == 'Detailed'
        ? '4-5 paragraphs'
        : '6-8 paragraphs';

    String prompt =
        '''Create a comprehensive $selectedGenre character profile.

Character: ${characterNameController.text}
Age: ${ageController.text.isNotEmpty ? ageController.text : 'Not specified'}
Personality: ${personalityController.text.isNotEmpty ? personalityController.text : 'Not specified'}
Role: ${roleController.text}
Details: ${additionalDetailsController.text.isNotEmpty ? GeminiOptimizerService.trimInput(additionalDetailsController.text, maxLength: GeminiOptimizerService.maxAdditionalDetailsLength) : 'None'}
Output Style: $selectedOutputStyle

Include these sections:
1. CHARACTER PROFILE heading with name
2. BACKSTORY ($backstoryLength): origin, key events, journey
3. STRENGTHS (4-6): physical, mental, social, unique talents
4. WEAKNESSES (3-5): flaws, vulnerabilities, fears
5. CHARACTER ARC: starting point → challenges → transformation → goal
6. DIALOGUE STYLE: vocabulary, tone, speech patterns
7. CATCHPHRASES: 5-7 memorable signature lines with context
8. SUMMARY: 2-3 sentence memorable summary

Make the character feel alive and authentic!
''';

    return prompt;
  }
}
