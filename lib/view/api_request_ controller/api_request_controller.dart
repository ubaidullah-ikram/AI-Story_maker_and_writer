import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ai_story_writer/model/story_model.dart';
import 'package:ai_story_writer/services/history_db.dart';
import 'package:ai_story_writer/services/query_manager_services.dart';
import 'package:ai_story_writer/view/pro_screen/pro_secreen.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiApiServiceController extends GetxController {
  final selectedAcademicLevel = 'High School'.obs;
  final selectedPaperType = 'Expository'.obs;
  final selectedScriptTone = 'YouTube Video'.obs;
  final selectedScriptType2 = 'Comedy'.obs;
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<void> saveStoryToDatabase({
    required String title,
    required String description,
    required String category,
  }) async {
    final story = StoryModel(
      title: title,
      description: description,
      category: category,
      createdAt: DateTime.now(),
    );
    await dbHelper.insertStory(story);
    log('Story saved to database: $title');
  }

  var userInputController = TextEditingController();
  // 🔑 Your API credentials
  final String apiKey = "AIzaSyD8MViTttwmWV1_t7nHeGsMI3MrKT72Jy4";
  final String baseUrl =
      "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent";

  // 🔹 Main function to call Gemini API
  Future<String?> callGeminiAPI({
    required String prompt,
    required toolName,
    required String title,
  }) async {
    try {
      log('Requesting to Gemini API...from tool $toolName');
      int remaingQueries = await QueryManager.getRemainingQueries();
      if (remaingQueries < 1) {
        Fluttertoast.showToast(msg: 'You have reached your free limit'.tr);
        Get.back();
        if (Get.find<ProScreenController>().isUserPro.value) {
          // user pro not going toh purchase
        } else {
          Get.to((ProScreen()));
        }
        return null;
      }
      log('allwoing request');
      // 🌐 HTTP POST Request
      final url = Uri.parse("$baseUrl?key=$apiKey");

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {"text": prompt},
                  ],
                },
              ],
            }),
          )
          .timeout(Duration(seconds: 30)); // ⏱️ 30 second timeout

      // ✅ Parse response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String result =
            data['candidates'][0]['content']['parts'][0]['text'] ??
            "No response!";
        log('✅ API Response received');
        // ❌ CHECK IF RESPONSE IS INVALID INPUT MESSAGE
        if (result.contains("INVALID INPUT") ||
            result.contains("INVALID_INPUT") ||
            result.contains("gibberish") ||
            result.contains("not a valid topic")) {
          userInputController.clear();
          Fluttertoast.showToast(
            msg: 'Please enter a valid topic or description'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Get.back();
          return null;
        }

        await saveStoryToDatabase(
          title: title,
          description: result,
          category: toolName, // Ya jo bhi category ho
        );
        await QueryManager.useQuery();
        return result;
      } else {
        log('❌ API Error: ${response.statusCode} - ${response.body}');
        return "Error: ${response.statusCode}";
      }
    } on SocketException {
      // 🌐 No internet connection
      log('❌ No Internet Connection');
      return "No Internet Connection. Please check your network.";
    } on TimeoutException {
      // ⏱️ Request timeout
      log('⏱️ Request Timeout');
      return "Request timeout. Please try again.";
    } catch (e) {
      // 🔴 Other errors
      log('❌ Error: $e');
      return "Error: $e";
    }
  }
}
