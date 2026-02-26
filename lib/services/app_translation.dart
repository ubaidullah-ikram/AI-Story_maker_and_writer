import 'package:ai_story_writer/constant/locallization/ar.dart';
import 'package:ai_story_writer/constant/locallization/de.dart';
import 'package:ai_story_writer/constant/locallization/en.dart';
import 'package:ai_story_writer/constant/locallization/es.dart';
import 'package:ai_story_writer/constant/locallization/fr.dart';
import 'package:ai_story_writer/constant/locallization/id.dart';
import 'package:ai_story_writer/constant/locallization/pt.dart';
import 'package:ai_story_writer/constant/locallization/ru.dart';
import 'package:ai_story_writer/constant/locallization/zh.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': en,
    'es': es,
    'ar': ar,
    "pt": pt,
    "de": de,
    "fr": fr,
    "id": id,
    "ru": ru,
    "zh": zh,
  };
}
