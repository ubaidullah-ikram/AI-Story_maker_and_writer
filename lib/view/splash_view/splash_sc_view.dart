import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/view/language_view/language_sc.dart';
import 'package:ai_story_writer/view_model/splash_controller/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScView extends StatefulWidget {
  const SplashScView({super.key});

  @override
  State<SplashScView> createState() => _SplashScViewState();
}

class _SplashScViewState extends State<SplashScView> {

var splashcontroller=Get.find<SplashController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashcontroller.loadSplashInterAd(context);
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.scaffoldbgColor,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(AppImages.story_writter_icon, height: 100),
              ),SizedBox(height: 10,),
              Text(
                'AI Story Writer'.tr,
                style: TextStyle(
                  fontFamily: AppFonts.inter,
                  fontSize: 20,
                  color: Colors.white,
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
      ),
    );
  }
}
