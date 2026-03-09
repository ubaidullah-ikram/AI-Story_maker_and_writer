import 'dart:io';
import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomRatingDialog extends StatefulWidget {
  const CustomRatingDialog({super.key});

  @override
  State<CustomRatingDialog> createState() => _CustomRatingDialogState();
}

class _CustomRatingDialogState extends State<CustomRatingDialog> {
  int _selectedRating = 0;
  bool _isSubmitting = false;

  Future<void> _launchStore() async {
    final String url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.ai.story.generator.novel.script.writer.maker'
        : 'https://apps.apple.com/app/id6755809339';

    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      debugPrint('Could not launch store: $e');
    }
  }

  Future<void> _submitRating() async {
    if (_selectedRating == 0) return;

    setState(() => _isSubmitting = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_rated_app', true);
    await prefs.setInt('user_rating', _selectedRating);

    if (_selectedRating >= 4) {
      // Good rating - redirect to store
      Get.back();
      await _launchStore();
    } else {
      // Low rating - just close and maybe show feedback option
      Get.back();
      _showFeedbackSnackbar();
    }
  }

  void _showFeedbackSnackbar() {
    Fluttertoast.showToast(
      msg: 'Thank you for rating us'.tr,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Appcolor.themeColor.withOpacity(0.9),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      backgroundColor:
          Colors.transparent, // backgroundColor: Colors.black.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // App Icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Appcolor.themeColor, Appcolor.themeColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Appcolor.themeColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(Icons.auto_stories, color: Colors.white, size: 36),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              'Enjoying AI Story Generator?'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8),

            // Subtitle
            Text(
              'Tap a star to rate your experience'.tr,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedRating = starIndex);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      _selectedRating >= starIndex
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 40,
                      color: _selectedRating >= starIndex
                          ? Appcolor.themeColor
                          : Colors.grey.shade400,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 8),

            // Rating text feedback
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _getRatingText(),
                key: ValueKey(_selectedRating),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _selectedRating >= 4
                      ? Appcolor.themeColor
                      : _selectedRating >= 3
                      ? Colors.orange
                      : _selectedRating > 0
                      ? Colors.redAccent
                      : Colors.transparent,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedRating > 0 && !_isSubmitting
                    ? _submitRating
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolor.themeColor,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Submit Rating'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Maybe Later
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Maybe Later'.tr,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText() {
    switch (_selectedRating) {
      case 1:
        return "We're sorry to hear that 😔".tr;
      case 2:
        return "We'll try to improve 🙁".tr;
      case 3:
        return "Thanks for your feedback 🙂".tr;
      case 4:
        return "Great! We're glad you like it 😊".tr;
      case 5:
        return "Awesome! Thank you so much! 🎉".tr;
      default:
        return '';
    }
  }
}

// Helper function to show the dialog
Future<void> showCustomRatingDialog() async {
  final prefs = await SharedPreferences.getInstance();
  final hasRated = prefs.getBool('has_rated_app') ?? false;

  if (hasRated) {
    return; // Don't show if already rated
  }

  Get.dialog(const CustomRatingDialog(), barrierDismissible: true);
}
