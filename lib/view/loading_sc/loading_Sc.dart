import 'dart:developer';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/view/api_request_%20controller/api_request_controller.dart';
import 'package:ai_story_writer/view/result_view/result_sc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AILoadingScreen extends StatefulWidget {
  final String? toolName;
  final String prompt;

  AILoadingScreen({Key? key, this.toolName, required this.prompt})
    : super(key: key);

  @override
  State<AILoadingScreen> createState() => _AILoadingScreenState();
}

class _AILoadingScreenState extends State<AILoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _textController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  var apiController = Get.find<GeminiApiServiceController>();
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    makeRequest();
    // Main animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Animate dots
    _textController.addListener(() {
      if (_textController.value == 0.0) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
        });
      }
    });
  }

  makeRequest() async {
    // Simulate a network request or any async operation
    // await Future.delayed(Duration(seconds: 5));
    apiController
        .callGeminiAPI(
          prompt: widget.prompt,
          toolName: widget.toolName ?? '',
          title: apiController.userInputController.text,
        )
        .then((response) {
          if (response != null) {
            apiController.userInputController.clear();
            log(
              'the response is ${response.length.toString()} characters long',
            );
            Get.off(() => ResultScView(resultText: response));
            // Get.to(()=>ResultScView());
          } else {
            // Get.back();
            // Fluttertoast.showToast(
            //   msg: 'Something went wrong. Please try again.'.tr,
            // );
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.scaffoldbgColor,
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     Color(0xFF667eea),
          //     Color(0xFF764ba2),
          //     Color(0xFFf093fb),
          //   ],
          // ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Appcolor.themeColor.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.auto_stories,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 50),

              // Loading text with animated dots
              Text(
                widget.toolName.toString().tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // Animated dots
              SizedBox(
                height: 30,
                child: Text(
                  '.' * _dotCount,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 5,
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Animated progress indicator
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Appcolor.themeColor,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),

              SizedBox(height: 20),

              // Subtitle text
              Text(
                'Please wait...'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage:
// 
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => AILoadingScreen(
//       loadingText: 'Kahani Generate Ho Rahi Hai',
//     ),
//   ),
// );
//
// API call ke baad:
// Navigator.pop(context); // Loading screen close karne ke liye