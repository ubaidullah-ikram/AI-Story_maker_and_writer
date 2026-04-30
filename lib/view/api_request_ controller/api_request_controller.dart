import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ai_story_writer/model/story_model.dart';
import 'package:ai_story_writer/services/history_db.dart';
import 'package:ai_story_writer/services/query_manager_services.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view/pro_screen/pro_secreen.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

  // 🔹 Main function to call Backend Gemini API
  Future<String?> callGeminiAPI({
    required String prompt,
    required toolName,
    required String title,
  }) async {
    try {
      log('Requesting to Backend API...from tool $toolName');
      // ignore: unused_local_variable
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
      log('allowing request');

      // 🌐 Backend endpoint. final url = "http://192.168.100.71:8000/api/gemini/vision";
      // aur yahan kuch append mat karo
      // final backendBase = "http://192.168.100.71:8000";
      final backendBase = RemoteConfigService().backendBaseUrl;
      final clientToken = RemoteConfigService().clientToken;
      final appId = RemoteConfigService().app_id;
      final url = Uri.parse('$backendBase/api/gemini/generate');
      log("its request for $toolName with prompt  and url is $url");
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'x-client-token': clientToken,
              'x-app-id': appId,
            },
            body: jsonEncode({'prompt': prompt}),
          )
          .timeout(const Duration(seconds: 140)); // ⏱️ 140 second timeout
      log("the fetching response from custom api is  ${response.body}");
      // ✅ Parse response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String result =
            data['result'] ??
            data['text'] ??
            data['response'] ??
            "No response!";
        log('✅ API Response received $data');

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
          category: toolName,
        );
        await QueryManager.useQuery();
        return result;
      } else {
        log('❌ API Error: ${response.statusCode} - ${response.body}');
        return "Error: ${response.statusCode}";
      }
    } on TimeoutException {
      // ⏱️ Request timeout
      log('⏱️ Request Timeout');
      return null;
    } catch (e) {
      // 🔴 Other errors
      log('❌ Error: $e');
      return "Error: $e";
    }
  }
}
