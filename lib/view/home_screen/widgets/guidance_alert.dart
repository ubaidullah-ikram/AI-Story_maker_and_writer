import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class QuickGuidanceDialog extends StatelessWidget {
  const QuickGuidanceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,insetPadding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,

        decoration: BoxDecoration(
          color: Appcolor.tileBackground,
          borderRadius: BorderRadius.circular(24),
        ),
        // decoration: BoxDecoration(
        //   gradient: const LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [
        //       Color(0xFF2D2540),
        //       Color(0xFF1A1625),
        //     ],
        //   ),
        //   borderRadius: BorderRadius.circular(24),
        // ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -30,
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

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                        Text(
                        'Quick Guidance ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,fontFamily: AppFonts.inter
                        ),
                      ),
                      const Text('⚡', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
            
                // Be specific section
                _buildSection(
                  icon: '🎯',
                  title: 'Be specific',
                  goodExample: '"A knight saves his village."',
                  badExample: '"A story"',
                ),
                const SizedBox(height: 20),
            
                // Give context section
                Container(decoration: BoxDecoration(color: Color(0xff212127)),
                  child: _buildSection(
                    icon: '🧠',
                    title: 'Give context',
                    goodExample: '"Two friends stuck on an island."',
                    badExample: '"Funny story"',
                  ),
                ),
                const SizedBox(height: 20),
            
                // Add emotions section
                _buildSection(
                  icon: '💬',
                  title: 'Add emotions',
                  goodExample: '"A lonely cat finds a home."',
                  badExample: '"A cat story"',
                ),
                const SizedBox(height: 20),
            
                // Full sentence section
                Container(decoration: BoxDecoration(color: Color(0xff212127)),
                  child: _buildSection(
                    icon: '📩',
                    title: 'Full sentence',
                    goodExample: '"Two strangers meet on a train."',
                    badExample: '"Love story"',
                  ),
                ),
                const SizedBox(height: 24),
            
                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child:   Text(
                        "Got It, Let's Write!",
                        style: TextStyle(
                          fontSize: 16,fontFamily: AppFonts.inter,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),SizedBox(height: 10,)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String icon,
    required String title,
    required String goodExample,
    required String badExample,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style:   TextStyle(fontFamily: AppFonts.inter,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildExample(true, goodExample),
          const SizedBox(height: 8),
          _buildExample(false, badExample),
        ],
      ),
    );
  }

  Widget _buildExample(bool isGood, String text) {
    return Row(
      children: [
        Icon(
          isGood ? Icons.check : Icons.close,
          color: isGood ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white ,
              fontSize: 14,fontFamily: AppFonts.inter
            ),
          ),
        ),
      ],
    );
  }
}
