import 'dart:io';
import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/view/language_view/language_sc.dart';
import 'package:ai_story_writer/view/pro_screen/pro_secreen.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
                      'Settings'.tr,
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                      () => Get.find<ProScreenController>().isUserPro.value
                          ? SizedBox.shrink()
                          : GestureDetector(
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
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Story cards list - YEH EXPANDED USE KARO
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildtile(
                      title: 'Language',
                      image: AppImages.language,
                      onTap: () {
                        Get.to(
                          () => LanguageSelectionScreen(isFromSetting: true),
                        );
                      },
                    ),
                    // buildtile(
                    //   title: 'Rate us',
                    //   image: AppImages.rate_us_icon,
                    //   onTap: () {
                    //       _launchURL(
                    //                       'https://play.google.com/store/apps/',
                    //                     );
                    //     // Get.to(()=>LanguageScreen());
                    //   },
                    // ),
                    // buildtile(
                    //   title: 'Share us',
                    //   image: AppImages.shareIcon,
                    //   onTap: () {
                    //     // Get.to(()=>LanguageScreen());
                    //   },
                    // ),
                    buildtile(
                      title: 'Rate Us',
                      onTap: () {
                        if (Platform.isAndroid) {
                          _launchURL(
                            'https://play.google.com/store/apps/details?id=com.ai.story.generator.novel.script.writer.maker',
                          );
                        } else {
                          _launchURL('https://apps.apple.com/app/id6755809339');
                        }
                      },
                      image: AppImages.privacy_policy,
                    ),
                    buildtile(
                      title: 'Terms and Conditions',
                      image: AppImages.terms_icon,
                      onTap: () {
                        _launchURL(
                          'https://pioneerdigital.tech/terms-and-conditions.html',
                        );
                        // Get.to(()=>LanguageScreen());
                      },
                    ),
                    buildtile(
                      title: 'Privacy Policy',
                      onTap: () {
                        _launchURL(
                          'https://pioneerdigital.tech/privacy-policy.html',
                        );
                        // Get.to(()=>LanguageScreen());
                      },
                      image: AppImages.privacy_policy,
                    ),
                  ],
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

  Future<void> _launchURL(String urlN) async {
    final Uri url = Uri.parse(urlN); // jis URL par jana hy
    try {
      await launchUrl(
        url,
        // mode: LaunchMode.externalApplication, // external browser khulega
      );
    } catch (e) {}
  }

  Widget buildtile({
    required String title,
    required String image,
    Function()? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xff1A1A1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF34343C), width: 1),
      ),
      child: Center(
        child: ListTile(
          onTap: onTap,
          title: Text(
            title.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.12),
            ),
            child: Center(child: Image.asset(image, height: 20)),
          ),
        ),
      ),
    );
  }
}

// STORY CARD WIDGET
class StoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String bottomLabel;
  final String timeAgo;
  final Color labelColor;
  final VoidCallback? onTap;

  const StoryCard({
    Key? key,
    required this.title,
    required this.description,
    required this.bottomLabel,
    required this.timeAgo,
    this.labelColor = Colors.red,
    this.onTap,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
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
                        // letterSpacing: -0.3,
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
                        // letterSpacing: -0.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ), // const SizedBox(height: 12),
              // // Divider
              Container(height: 1, color: const Color(0xFF34343C)),

              // const SizedBox(height: 12),

              // Bottom row with label and time
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 14,
                ),
                decoration: BoxDecoration(color: Color(0xff212127)),
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
                      bottomLabel,
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
