import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart'; 
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';

class HistyDetailView extends StatefulWidget {
  String title;
  String text;
  HistyDetailView({Key? key, required this.text,required this.title}) : super(key: key);

  @override
  State<HistyDetailView> createState() => _HistyDetailViewState();
}

class _HistyDetailViewState extends State<HistyDetailView> {
 
@override
  void initState() {
    // TODO: implement initState
    inputScreenController.text=widget.text;
    super.initState();
  }
  var inputScreenController = TextEditingController();
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
                      widget.title.tr,
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
      // height: 280,
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(widget.text,style:  TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: AppFonts.inter,
          ),),
      ),
      // child: TextField(
      //   controller: inputScreenController,
      //   maxLines: null,
      //   expands: true,
      //   style: TextStyle(
      //     color: Colors.white,
      //     fontSize: 16,
      //     fontFamily: AppFonts.inter,
      //   ),
      //   decoration: InputDecoration(
      //     hintText: 'Describe your topic...'.tr,
      //     hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
      //     border: InputBorder.none,
      //     contentPadding: EdgeInsets.all(20),
      //   ),
      // ),
    );
  }



 }
