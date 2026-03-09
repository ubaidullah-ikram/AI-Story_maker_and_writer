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

class TitleGeneratorInputScreen extends StatefulWidget {
  const TitleGeneratorInputScreen({Key? key}) : super(key: key);

  @override
  State<TitleGeneratorInputScreen> createState() =>
      _TitleGeneratorInputScreenState();
}

class _TitleGeneratorInputScreenState extends State<TitleGeneratorInputScreen> {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController keywordsController = TextEditingController();

  String selectedGenre = 'Fantasy';
  String selectedType = 'Book';
  String selectedStyle = 'Creative';
  int titleCount = 10;

  var apiController = Get.find<GeminiApiServiceController>();

  final List<String> genres = [
    'Fantasy',
    'Romance',
    'Mystery',
    'Horror',
    'Sci-Fi',
    'Thriller',
    'Comedy',
    'Drama',
    'Adventure',
    'Kids',
  ];

  final List<String> types = [
    'Book',
    'Short Story',
    'Novel',
    'Chapter',
    'Series',
  ];

  final List<String> styles = [
    'Creative',
    'Simple',
    'Mysterious',
    'Dramatic',
    'Catchy',
    'Poetic',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    topicController.dispose();
    keywordsController.dispose();
    super.dispose();
  }

  void _navigateToLoadingScreen() {
    Get.to(
      () => AILoadingScreen(
        toolName: "Title Generator",
        prompt: generateTitlePrompt(),
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
                        'Title Generator'.tr,
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
                        _buildSectionTitle('Story/Book Topic'.tr),
                        const SizedBox(height: 12),
                        _buildTopicInput(),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Keywords (Optional)'.tr),
                        const SizedBox(height: 12),
                        _buildKeywordsInput(),
                        const SizedBox(height: 24),
                        _buildGenreSelector(),
                        const SizedBox(height: 24),
                        _buildTypeSelector(),
                        const SizedBox(height: 24),
                        _buildStyleSelector(),
                        const SizedBox(height: 24),
                        _buildTitleCountSelector(),
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
      height: 120,
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
        expands: true,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.inter,
        ),
        decoration: InputDecoration(
          hintText: 'Describe your story topic or theme...'.tr,
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
          hintText: 'e.g., magic, dragon, adventure'.tr,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          prefixIcon: Icon(Icons.key, color: Appcolor.themeColor),
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

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Title For'.tr),
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

  Widget _buildStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Title Style'.tr),
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

  Widget _buildTitleCountSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Number of Titles'.tr),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Appcolor.themeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$titleCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            activeTrackColor: Appcolor.themeColor,
            inactiveTrackColor: Colors.grey.shade700,
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 12,
              elevation: 4,
            ),
            overlayColor: Appcolor.themeColor.withOpacity(0.3),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: titleCount.toDouble(),
            onChanged: (value) {
              setState(() {
                titleCount = value.toInt();
              });
            },
            min: 5,
            max: 20,
            divisions: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return GestureDetector(
      onTap: () async {
        if (topicController.text.isEmpty) {
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
        FocusManager.instance.primaryFocus?.unfocus();

        // Set the title for history
        apiController.userInputController.text =
            "Titles: ${topicController.text}";
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
              'Generate Titles'.tr,
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

  String generateTitlePrompt() {
    String prompt =
        '''
CRITICAL INSTRUCTION - READ FIRST:
1. Before generating, silently verify the topic is valid
2. If topic is gibberish/invalid → ONLY respond with: "INVALID_INPUT: Please provide a valid topic for title generation."
3. If topic is VALID → Go DIRECTLY to generating titles without any preamble.

---

You are an expert creative writer and title specialist. Generate $titleCount unique and compelling titles for a $selectedType.

INPUT DETAILS:
- Topic/Theme: ${topicController.text}
- Genre: $selectedGenre
- Keywords: ${keywordsController.text.isNotEmpty ? keywordsController.text : 'None specified'}
- Title Style: $selectedStyle
- Format: $selectedType

TITLE STYLE GUIDELINES:
${selectedStyle == 'Creative' ? '- Use imaginative, unique combinations and unexpected word pairings' : ''}
${selectedStyle == 'Simple' ? '- Use clear, straightforward titles that are easy to remember' : ''}
${selectedStyle == 'Mysterious' ? '- Create intriguing titles that spark curiosity and questions' : ''}
${selectedStyle == 'Dramatic' ? '- Use powerful, emotionally charged words and phrases' : ''}
${selectedStyle == 'Catchy' ? '- Create memorable, hook-like titles that grab attention' : ''}
${selectedStyle == 'Poetic' ? '- Use beautiful, lyrical language with rhythm and flow' : ''}

OUTPUT FORMAT:

## 📚 $titleCount ${selectedType.toUpperCase()} TITLES

### 🎯 Top Recommendations

1. **[Title 1]**
   - *Why it works:* Brief explanation

2. **[Title 2]**
   - *Why it works:* Brief explanation

3. **[Title 3]**
   - *Why it works:* Brief explanation

### 📝 More Options

4. [Title 4]
5. [Title 5]
... (continue to $titleCount)

### 💡 Title Tips
- Brief advice on choosing the perfect title for this genre

Make each title unique, memorable, and perfectly suited for a $selectedGenre $selectedType!
''';

    return prompt;
  }
}
