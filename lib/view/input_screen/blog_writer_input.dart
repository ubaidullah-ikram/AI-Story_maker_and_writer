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

class BlogWriterInputScreen extends StatefulWidget {
  const BlogWriterInputScreen({Key? key}) : super(key: key);

  @override
  State<BlogWriterInputScreen> createState() => _BlogWriterInputScreenState();
}

class _BlogWriterInputScreenState extends State<BlogWriterInputScreen> {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController keywordsController = TextEditingController();
  final TextEditingController targetAudienceController =
      TextEditingController();

  String selectedLength = 'Medium';
  String selectedTone = 'Professional';
  String selectedType = 'SEO Article';
  bool includeMetaDescription = true;
  bool includeKeywordSuggestions = true;
  bool includeFAQs = true;

  var apiController = Get.find<GeminiApiServiceController>();

  final List<String> lengths = [
    'Short (500-800)',
    'Medium (800-1500)',
    'Long (1500-2500)',
    'Detailed (2500+)',
  ];

  final List<String> tones = [
    'Professional',
    'Casual',
    'Informative',
    'Persuasive',
    'Friendly',
    'Authoritative',
  ];

  final List<String> types = [
    'SEO Article',
    'How-To Guide',
    'Listicle',
    'Product Review',
    'Opinion Piece',
    'News Article',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    topicController.dispose();
    keywordsController.dispose();
    targetAudienceController.dispose();
    super.dispose();
  }

  void _navigateToLoadingScreen() {
    Get.to(
      () => AILoadingScreen(
        toolName: "Blog Writer",
        prompt: generateBlogPrompt(),
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
                        'Blog Writer'.tr,
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
                        _buildSectionTitle('Blog Topic'.tr),
                        const SizedBox(height: 12),
                        _buildTopicInput(),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Target Keywords'.tr),
                        const SizedBox(height: 12),
                        _buildKeywordsInput(),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Target Audience (Optional)'.tr),
                        const SizedBox(height: 12),
                        _buildAudienceInput(),
                        const SizedBox(height: 24),
                        _buildTypeSelector(),
                        const SizedBox(height: 24),
                        _buildToneSelector(),
                        const SizedBox(height: 24),
                        _buildLengthSelector(),
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
          hintText: 'Enter your blog topic or title...'.tr,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildKeywordsInput() {
    return Container(
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: TextField(
        controller: keywordsController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.inter,
        ),
        decoration: InputDecoration(
          hintText: 'e.g., AI writing, content marketing, SEO tips'.tr,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          prefixIcon: Icon(Icons.key, color: Appcolor.themeColor),
        ),
      ),
    );
  }

  Widget _buildAudienceInput() {
    return Container(
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: TextField(
        controller: targetAudienceController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.inter,
        ),
        decoration: InputDecoration(
          hintText: 'e.g., small business owners, bloggers'.tr,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          prefixIcon: Icon(Icons.people, color: Appcolor.themeColor),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Article Type'.tr),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: types.map((type) {
              bool isSelected = selectedType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = type;
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
                        type.tr,
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

  Widget _buildToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Writing Tone'.tr),
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

  Widget _buildLengthSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Article Length'.tr),
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
                        length.tr,
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

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('SEO Options'.tr),
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
              _buildOptionSwitch(
                'Include Meta Description'.tr,
                includeMetaDescription,
                (value) {
                  setState(() {
                    includeMetaDescription = value;
                  });
                },
              ),
              Divider(color: Color(0xff34343C)),
              _buildOptionSwitch(
                'Include Keyword Suggestions'.tr,
                includeKeywordSuggestions,
                (value) {
                  setState(() {
                    includeKeywordSuggestions = value;
                  });
                },
              ),
              Divider(color: Color(0xff34343C)),
              _buildOptionSwitch('Include FAQs Section'.tr, includeFAQs, (
                value,
              ) {
                setState(() {
                  includeFAQs = value;
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
            msg: "Please enter a blog topic".tr,
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
              'Generate Blog'.tr,
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

  String generateBlogPrompt() {
    final trimmedTopic = GeminiOptimizerService.trimInput(topicController.text);
    final trimmedKeywords = GeminiOptimizerService.trimInput(
      keywordsController.text,
      maxLength: GeminiOptimizerService.maxKeywordsLength,
    );
    final trimmedAudience = GeminiOptimizerService.trimInput(
      targetAudienceController.text,
      maxLength: GeminiOptimizerService.maxKeywordsLength,
    );

    String prompt =
        '''Write a comprehensive, SEO-optimized $selectedType blog article.

Topic: $trimmedTopic
Keywords: ${trimmedKeywords.isNotEmpty ? trimmedKeywords : 'Generate relevant keywords'}
Audience: ${trimmedAudience.isNotEmpty ? trimmedAudience : 'General'}
Tone: $selectedTone
Length: $selectedLength words

SEO: Use primary keyword in title and first paragraph, proper H1/H2/H3 structure, short scannable paragraphs.

${includeMetaDescription ? 'Include: META DESCRIPTION (150-160 chars) and SEO TITLE TAG (under 60 chars).' : ''}
${includeKeywordSuggestions ? 'Include: KEYWORD ANALYSIS with primary, secondary, and LSI keywords.' : ''}

Write the complete article with proper headings, engaging intro, valuable content, and strong conclusion.

${includeFAQs ? 'Include: 4 relevant FAQs with concise answers.' : ''}

Add a CONTENT SUMMARY with word count, reading time, and readability score.
''';

    return prompt;
  }
}
