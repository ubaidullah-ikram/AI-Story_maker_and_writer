import 'dart:developer';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class LocalController extends GetxController {
  // Save and change language
  int selectedLanguage = -1;
  RxString selectedlngCode = 'en'.obs;
  Future<void> changeLanguage(
    int index,
    List<Map<String, String>> languages,
  ) async {
    String languageCode = languages[index]['code']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    selectedlngCode.value = languageCode;
    log("The selected language is ${languageCode}");
    // Change locale
    Get.updateLocale(Locale(languageCode));

    selectedLanguage = index;
  }

  // Load saved language
  Future<void> loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('language_code');
    log('the saved language is $savedLanguage');
    selectedlngCode.value = savedLanguage ?? 'en';

    log("The loaded language is ${selectedlngCode.value}");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadSavedLanguage();
  }
}
