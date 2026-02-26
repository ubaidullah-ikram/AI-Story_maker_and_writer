import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:ai_story_writer/model/story_model.dart';
import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/res/your_story_history/widgets/histy_detail_view.dart';
import 'package:ai_story_writer/services/admanage_service.dart';
import 'package:ai_story_writer/services/history_db.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view/pro_screen/pro_secreen.dart';
import 'package:ai_story_writer/view_model/history_controller/history_controller.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
// Import your database helper

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final List<String> historyFilter = [
    'All',
    'Story Generator',
    'Essay Writer',
    'Script Generator',
  ];
  String selectedHistoryTab = 'All';
  List<StoryModel> stories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStories();
    // if (!Get.find<ProScreenController>().isUserPro.value) {
    //   if (Platform.isIOS) {
    //     if (RemoteConfigService().native_ad_for_IOS) {
    //       loadAd();
    //     }
    //   } else {
    //     if (RemoteConfigService().native_ad_for_android) {
    //       loadAd();
    //     }
    //   }
    // }
  }

  var historyController = Get.put(HistoryController());
  // Load stories from database
  Future<void> _loadStories() async {
    setState(() => isLoading = true);

    try {
      List<StoryModel> loadedStories;

      if (selectedHistoryTab == 'All') {
        loadedStories = await DatabaseHelper.instance.getAllStories();
      } else {
        loadedStories = await DatabaseHelper.instance.getStoriesByCategory(
          selectedHistoryTab,
        );
      }

      setState(() {
        stories = loadedStories;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading stories: $e');
      setState(() => isLoading = false);
    }
  }

  // Get color based on category
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Story Generator':
        return const Color(0xFFEF4444); // Red
      case 'Essay Writer':
        return const Color(0xFF3B82F6); // Blue
      case 'Script Generator':
        return const Color(0xFF10B981); // Green
      default:
        return const Color(0xFFEF4444);
    }
  }

  // Get time ago string
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Delete story with confirmation
  Future<void> _deleteStory(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Appcolor.tileBackground,
        title: Text('Delete Story', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this story?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteStory(id);
      _loadStories(); // Refresh list
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Story deleted successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 10),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Stories'.tr,
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                      () => !Get.find<ProScreenController>().isUserPro.value
                          ? GestureDetector(
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
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Filter chips
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: historyFilter.map((genre) {
                    bool isSelected = selectedHistoryTab == genre;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedHistoryTab = genre;
                          });
                          _loadStories(); // Reload with filter
                        },
                        child: Container(
                          height: SizeConfig.h(36),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Appcolor.themeColor
                                : Appcolor.tileBackground,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Color(0xff34343C),
                              width: 1,
                            ),
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
            ),

            // Story cards list
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Appcolor.themeColor,
                      ),
                    )
                  : stories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(
                            () => historyController.isBannerAdLoaded.value
                                ? Container(
                                    margin: EdgeInsets.only(top: 10),
                                    height: 60,
                                    width: double.infinity,
                                    // color: Color(0xff2A2A2E),
                                    child: Center(
                                      child: AdManager.getBannerWidget(
                                        historyController.bannerAd,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ),
                          Spacer(),
                          Image.asset(AppImages.no_stories, height: 80),
                          SizedBox(height: 16),
                          Text(
                            'Your Story Space Awaits'.tr,
                            style: TextStyle(
                              fontFamily: AppFonts.inter,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start your first story and see it appear here'.tr,
                            style: TextStyle(
                              fontFamily: AppFonts.inter,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadStories,
                      color: Appcolor.themeColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount:
                            stories.length +
                            (_isLoaded && _nativeAd != null
                                ? 1
                                : 0), // ✅ Yeh add karo
                        itemBuilder: (context, index) {
                          final bool isAdVisible =
                              _isLoaded && _nativeAd != null;

                          // // Ad position pe return karo
                          // if (index == 1 && isAdVisible) {
                          //   return Container(
                          //     height: 110,
                          //     margin: EdgeInsets.symmetric(vertical: 8),
                          //     child: AdWidget(ad: _nativeAd!),
                          //   );
                          // }

                          // Story index - SIRF jab ad visible hai tab adjust karo
                          int storyIndex = index;
                          if (isAdVisible && index > 1) {
                            storyIndex = index - 1;
                          }

                          // Safety check
                          if (storyIndex >= stories.length) {
                            return SizedBox.shrink();
                          }

                          final story = stories[storyIndex];

                          return StoryCard(
                            title: story.title,
                            description: story.description,
                            bottomLabel: story.category,
                            timeAgo: _getTimeAgo(story.createdAt),
                            labelColor: _getCategoryColor(story.category),
                            onTap: () {
                              print('Story tapped: ${story.title}');

                              Get.to(
                                () => HistyDetailView(
                                  text: story.description,
                                  title: story.category,
                                ),
                              );
                            },
                            onLongPress: () {
                              if (story.id != null) {
                                _deleteStory(story.id!);
                              }
                            },
                          );
                        },
                      ),
                    ),
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

  @override
  void dispose() {
    // TODO: implement dispose

    _isLoaded = false;
    // setState(() {});
    _nativeAd?.dispose();
    super.dispose();
  }

  NativeAd? _nativeAd;
  bool _isLoaded = false;

  // void loadAd() {
  //   _nativeAd = NativeAd(
  //     adUnitId: AdIds.nativeAdId,
  //     listener: NativeAdListener(
  //       onAdLoaded: (ad) {
  //         log('native ad loaded.');
  //         setState(() {
  //           _isLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         log('native ad failedToLoad: $error');
  //         ad.dispose();
  //       },
  //       onAdClicked: (ad) {},
  //       onAdImpression: (ad) {},
  //       onAdClosed: (ad) {},
  //       onAdOpened: (ad) {},
  //       onAdWillDismissScreen: (ad) {},
  //       onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
  //     ),
  //     request: const AdRequest(),
  //     nativeTemplateStyle: NativeTemplateStyle(
  //       templateType: TemplateType.small,
  //     ),
  //   )..load();
  // }
}

// STORY CARD WIDGET
class StoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String bottomLabel;
  final String timeAgo;
  final Color labelColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const StoryCard({
    Key? key,
    required this.title,
    required this.description,
    required this.bottomLabel,
    required this.timeAgo,
    this.labelColor = Colors.red,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF34343C), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          // borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: const Color(0xFF34343C)),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: const Color(0xFF34343C)),

              // Bottom row with label and time
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Color(0xff212127),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    // Dot indicator
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: labelColor,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Label
                    Text(
                      bottomLabel.tr,
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    // Time ago
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
