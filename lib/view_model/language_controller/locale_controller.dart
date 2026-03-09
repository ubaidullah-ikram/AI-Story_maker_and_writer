import 'dart:developer';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class LocalController extends GetxController {
  // Save and change language
  int selectedLanguage = -1;
  RxString selectedlngCode = 'en'.obs;

  // Supported language codes in the app
  final List<String> supportedLanguages = [
    'en',
    'es',
    'ar',
    'pt',
    'de',
    'fr',
    'id',
    'ru',
    'zh',
    // New languages for device locale support
    'af', // Afrikaans
    'sq', // Albanian
    'am', // Amharic
    'hy', // Armenian
    'az', // Azerbaijani
    'bn', // Bangla
    'eu', // Basque
    'be', // Belarusian
    'bg', // Bulgarian
    'my', // Burmese
    'ca', // Catalan
    // Remaining locales from AppTranslations
    'cs', // Czech
    'da', // Danish
    'el', // Greek
    'et', // Estonian
    'fa', // Persian
    'fi', // Finnish
    'fil', // Filipino
    'gl', // Galician
    'gu', // Gujarati
    'he', // Hebrew
    'hi', // Hindi
    'hr', // Croatian
    'hu', // Hungarian
    'is', // Icelandic
    'it', // Italian
    'ja', // Japanese
    'ka', // Georgian
    'kk', // Kazakh
    'km', // Khmer
    'kn', // Kannada
    'ko', // Korean
    'ky', // Kyrgyz
    'lo', // Lao
    'lv', // Latvian
    'mk', // Macedonian
    'mn', // Mongolian
    'ms', // Malay
    'ne', // Nepali
    'nl', // Dutch
    'no', // Norwegian
    'pa', // Punjabi
    'pl', // Polish
    'ro', // Romanian
    'si', // Sinhala
    'sk', // Slovak
    'sl', // Slovenian
    'sr', // Serbian
    'sv', // Swedish
    'sw', // Swahili
    'ta', // Tamil
    'th', // Thai
    'tr', // Turkish
    'uk', // Ukrainian
    'ur', // Urdu
    'vi', // Vietnamese
    'zu', // Zulu
  ];

  Future<void> changeLanguage(
    int index,
    List<Map<String, String>> languages,
  ) async {
    String languageCode = languages[index]['code']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    // Mark that user has manually selected a language
    await prefs.setBool('language_selected_by_user', true);
    selectedlngCode.value = languageCode;
    log("The selected language is ${languageCode}");
    // Change locale
    Get.updateLocale(Locale(languageCode));

    selectedLanguage = index;
  }

  // Load saved language or detect device language
  Future<void> loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? userSelectedLanguage = prefs.getBool('language_selected_by_user');

    if (userSelectedLanguage == true) {
      // User has previously selected a language, use that
      String? savedLanguage = prefs.getString('language_code');
      selectedlngCode.value = savedLanguage ?? 'en';
      log('Using user-selected language: ${selectedlngCode.value}');
    } else {
      // First time or reinstall - detect device language
      String deviceLanguage = _getDeviceLanguage();
      selectedlngCode.value = deviceLanguage;
      log('Using device language: ${selectedlngCode.value}');
    }

    log("The loaded language is ${selectedlngCode.value}");
  }

  // Get device language and match with supported languages
  String _getDeviceLanguage() {
    // Get device locale
    Locale deviceLocale = PlatformDispatcher.instance.locale;
    String deviceLangCode = deviceLocale.languageCode;

    log('Device locale detected: ${deviceLocale.toString()}');
    log('Device language code: $deviceLangCode');

    // Check if device language is supported
    if (supportedLanguages.contains(deviceLangCode)) {
      return deviceLangCode;
    }

    // Fallback to English if device language is not supported
    return 'en';
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadSavedLanguage();
  }
}
