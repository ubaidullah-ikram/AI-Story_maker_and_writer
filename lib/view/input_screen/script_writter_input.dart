import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/services/ad_counter_services.dart';
import 'package:ai_story_writer/services/admanage_service.dart';
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
    required String scriptFormat, // YouTube Video, Short Film, etc.
    required String scriptGenre, // Comedy, Drama, Horror, etc.
  }) {
    String prompt =
        '''
CRITICAL INSTRUCTION - READ FIRST:
1. Before writing anything, silently verify the topic validity
2. If topic is gibberish/invalid → ONLY respond with: "INVALID_INPUT: The provided topic is gibberish or invalid. Please provide a meaningful topic."
3. If topic is VALID → Do NOT say anything about validation. Do NOT say "Okay, I will create..." or any preamble. Go DIRECTLY to writing the script. Do not include any introduction, confirmation, or acknowledgment text.

---


You are a professional script writer. Create an engaging, well-structured script based on the following parameters:

📝 SCRIPT BRIEF:
Topic/Concept: $topic
Format: $scriptFormat
Genre: $scriptGenre

${_getFormatGuidelines(scriptFormat)}

${_getGenreGuidelines(scriptGenre)}

SCRIPT REQUIREMENTS:
1. Start with a powerful hook in the first 10 seconds
2. Maintain consistent $scriptGenre tone throughout
3. Include clear scene descriptions and visual cues
4. Write natural, engaging dialogue
5. Add [VISUAL NOTES], (AUDIO CUES), and *emotion/action* descriptions
6. End with strong impact or call-to-action

FORMAT INSTRUCTIONS:
- Use proper script formatting
- Include timing/duration notes
- Add camera angles for visual formats
- Specify transitions between scenes

Write the complete, production-ready script now:

---
''';

    return prompt;
  }

  String _getFormatGuidelines(String format) {
    switch (format) {
      case 'YouTube Video':
        return '''
🎥 YOUTUBE VIDEO FORMAT:
- Duration: 8-12 minutes
- Structure:
  * HOOK (0:00-0:10): Grab attention immediately
  * INTRO (0:10-0:45): Channel intro, topic overview
  * MAIN CONTENT (0:45-9:00): 3-4 clear sections with [B-ROLL] suggestions
  * OUTRO (9:00-10:00): Summary, CTA, subscribe reminder
- Include engagement prompts (like, comment, subscribe)
- Add [GRAPHICS/TEXT OVERLAY] suggestions
- Mark good spots for jump cuts''';

      case 'Short Film':
        return '''
🎬 SHORT FILM FORMAT:
- Duration: 5-15 minutes
- Use standard screenplay format:
  * INT./EXT. - LOCATION - TIME
  * Character names in CAPS before dialogue
  * Action in present tense
  * Camera angles: (CLOSE UP), (WIDE SHOT), (POV), etc.
- Include character emotions and movements
- Add scene transitions: CUT TO, FADE TO, DISSOLVE TO
- Build story arc: Setup → Conflict → Resolution''';

      case 'Advertisement':
        return '''
📺 ADVERTISEMENT FORMAT:
- Duration: 30-60 seconds
- Structure:
  * OPENING (0-5 sec): Hook/Problem
  * BODY (5-45 sec): Solution/Product showcase
  * CLOSING (45-60 sec): Brand message/CTA
- Include:
  * VOICEOVER (V.O.) clearly marked
  * [PRODUCT SHOTS] descriptions
  * [BACKGROUND MUSIC] suggestions
  * Bold tagline/slogan at end
- Keep it punchy and memorable''';

      case 'Podcast':
        return '''
🎙️ PODCAST FORMAT:
- Duration: 15-30 minutes
- Structure:
  * COLD OPEN (0-1 min): Teaser or hook
  * INTRO (1-2 min): Welcome, topic intro, sponsor message
  * MAIN SEGMENTS (2-25 min): 2-3 segments with clear transitions
  * OUTRO (25-30 min): Recap, CTA, credits
- Include:
  * [MUSIC: Intro/Outro/Transition]
  * [SOUND EFFECTS] where relevant
  * Natural conversation flow
  * Listener engagement questions''';

      case 'Reel':
        return '''
📱 INSTAGRAM REEL FORMAT:
- Duration: 15-60 seconds
- Fast-paced, attention-grabbing
- Structure:
  * HOOK (0-3 sec): Stop the scroll!
  * CONTENT (3-50 sec): Quick value/entertainment
  * CTA (50-60 sec): Follow, save, share
- Include:
  * [TEXT OVERLAYS] at key moments
  * [TRENDING AUDIO] suggestions
  * Quick cuts and transitions
  * Vertical format (9:16) notes''';

      case 'Tiktok Video':
        return '''
🎵 TIKTOK VIDEO FORMAT:
- Duration: 15-60 seconds
- Viral-focused, trend-aware
- Structure:
  * HOOK (0-1 sec): Immediate attention grab
  * BUILD-UP (1-45 sec): Story/trend execution
  * PAYOFF (45-60 sec): Punchline/reveal
- Include:
  * [TRENDING SOUND] integration
  * [TEXT EFFECTS] timing
  * Quick transitions
  * Hashtag suggestions
  * Duet/Stitch potential''';

      case 'Movie':
        return '''
🎞️ MOVIE SCENE FORMAT:
- Duration: 3-5 minutes (single scene)
- Professional screenplay format:
  * Proper scene headings
  * Character development
  * Cinematic descriptions
  * Dialogue with subtext
- Include:
  * Detailed camera work
  * Lighting and mood notes
  * Character blocking
  * Emotional beats
  * Scene purpose in larger narrative''';

      case 'Film Script':
        return '''
🎬 FILM SCRIPT FORMAT:
- Professional screenplay format
- Standard industry formatting:
  * INT./EXT. LOCATION - DAY/NIGHT
  * Character names centered and CAPITALIZED
  * Parentheticals for delivery notes
  * Action lines in present tense
- Include:
  * Scene numbers
  * Camera directions (ANGLE ON, CLOSE UP, etc.)
  * Transitions (CUT TO, DISSOLVE TO)
  * Character introductions with brief descriptions
  * Proper pagination and margins''';

      case 'Stage Play':
        return '''
🎭 STAGE PLAY FORMAT:
- Theatrical script format
- Structure:
  * ACT and SCENE divisions
  * Set descriptions at start of each scene
  * Character entrances and exits clearly marked
  * Stage directions in brackets [Character crosses to window]
- Include:
  * UPSTAGE, DOWNSTAGE, STAGE LEFT/RIGHT directions
  * Lighting cues: (LIGHTS DIM)
  * Sound cues: (SOUND: Thunder)
  * Costume and prop notes
  * Pause and beat indicators''';

      case 'Scene Breakdown':
        return '''
📋 SCENE BREAKDOWN FORMAT:
- Detailed analysis format
- For each scene include:
  * Scene number and title
  * INT/EXT and location
  * Time of day
  * Characters present
  * Props needed
  * Wardrobe requirements
  * Vehicles/animals
  * Special effects
  * Stunts required
  * Background extras
  * Key dialogue moments
  * Emotional tone
  * Estimated duration
- Production-ready format''';

      case 'Dialogue Only':
        return '''
💬 DIALOGUE ONLY FORMAT:
- Pure dialogue script
- Format:
  CHARACTER NAME:
  "Dialogue line here"
  
  ANOTHER CHARACTER:
  "Response here"
- Include:
  * Character emotions in (parentheses)
  * Brief action beats in [brackets]
  * Natural conversation flow
  * No scene descriptions
  * No camera directions
  * Focus purely on spoken words
- Perfect for table reads and voice recording''';

      default:
        return '''
STANDARD SCRIPT FORMAT:
- Clear beginning, middle, and end
- Proper formatting for chosen medium
- Visual and audio cues included''';
    }
  }

  String _getGenreGuidelines(String genre) {
    switch (genre) {
      case 'Comedy':
        return '''
😂 COMEDY GENRE ELEMENTS:
- Setup-punchline structure
- Include [PAUSE FOR LAUGH] markers
- Physical comedy opportunities
- Witty dialogue and wordplay
- Comedic timing notes
- Callback jokes
- Exaggeration and absurdity
- Keep energy high and fun''';

      case 'Drama':
        return '''
🎭 DRAMA GENRE ELEMENTS:
- Emotional depth and character development
- Conflict and tension building
- Meaningful dialogue
- Realistic situations
- Character motivations clear
- Emotional beats marked
- Subtle performances
- Authentic relationships''';

      case 'Horror':
        return '''
😱 HORROR GENRE ELEMENTS:
- Build suspense and dread
- Jump scare opportunities marked
- [CREEPY SOUND EFFECTS] noted
- Dark atmosphere descriptions
- Tension through pacing
- Fear of the unknown
- Disturbing visuals described
- Psychological elements
- Use silence effectively''';

      case 'Action':
        return '''
💥 ACTION GENRE ELEMENTS:
- Fast-paced sequences
- Clear choreography descriptions
- [SOUND EFFECTS: explosions, impacts]
- Dynamic camera movements
- Tension and stakes
- Physical conflicts detailed
- Quick cuts and energy
- Hero moments
- Adrenaline-pumping scenes''';

      case 'Romance':
        return '''
💕 ROMANCE GENRE ELEMENTS:
- Chemistry between characters
- Emotional vulnerability
- Tender moments described
- Romantic tension building
- Heartfelt dialogue
- Intimate scene settings
- Character connection focus
- [ROMANTIC MUSIC] cues
- Genuine emotions''';

      case 'Motivational':
        return '''
💪 MOTIVATIONAL GENRE ELEMENTS:
- Inspiring message
- Relatable struggles shown
- Uplifting narrative arc
- Powerful voiceover moments
- Success and transformation
- Empowering language
- Call-to-action focused
- Emotional high points
- Hope and determination''';

      case 'Mystery':
        return '''
🔍 MYSTERY GENRE ELEMENTS:
- Intriguing setup with questions
- Clues planted throughout
- Red herrings and misdirection
- Suspenseful pacing
- Investigation sequences
- Plot twists prepared
- Reveal moments marked
- Atmospheric tension
- Puzzle-solving satisfaction''';

      case 'Fairy Tale':
        return '''
✨ FAIRY TALE GENRE ELEMENTS:
- "Once upon a time" storytelling
- Magical elements
- Clear good vs evil
- Moral lesson woven in
- Whimsical descriptions
- Fantastical creatures/settings
- Hero's journey structure
- Happy ending focus
- Timeless, enchanting tone''';

      case 'Thriller':
        return '''
🔪 THRILLER GENRE ELEMENTS:
- High stakes and urgency
- Constant tension
- Plot twists and turns
- Suspenseful pacing
- Danger and threat present
- Psychological elements
- Race against time
- Edge-of-seat moments
- Unpredictable events''';

      case 'Sci-Fi':
        return '''
🚀 SCI-FI GENRE ELEMENTS:
- Futuristic or advanced technology
- Scientific concepts explained simply
- World-building details
- Innovative gadgets and systems
- Space, AI, or time travel themes
- Thought-provoking concepts
- Visual effects descriptions
- Unique terminology/jargon
- Balance of wonder and realism''';

      case 'Kids':
        return '''
👶 KIDS GENRE ELEMENTS:
- Age-appropriate content (5-12 years)
- Simple, clear language
- Fun and colorful descriptions
- Educational elements woven in
- Positive messages and morals
- Engaging characters (animals, heroes)
- Adventure and imagination focus
- No scary or violent content
- Short attention span friendly
- Interactive moments''';

      default:
        return '''
GENRE CONSIDERATIONS:
- Match tone consistently
- Use appropriate pacing
- Include genre-specific elements''';
    }
  }
}
