import 'package:ai_story_writer/firebase_options.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/services/app_translation.dart';
import 'package:ai_story_writer/services/query_manager_services.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/services/revnue_cat_service.dart';
import 'package:ai_story_writer/view/splash_view/splash_sc_view.dart';
import 'package:ai_story_writer/view_model/language_controller/lanugage_controller.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:ai_story_writer/view_model/splash_controller/splash_screen_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {}
  await MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env"); // Add this line

  try {
    await RevenueCatHelper().initPlatformState();
  } catch (e) {}

  Get.put(LocalController());
  Get.put(ProScreenController());
  try {
    await RemoteConfigService().init();
  } catch (e) {}
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  Get.put(SplashController());
  try {
    QueryManager.initialize();
  } catch (e) {}
  // Get.put(HomeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var localcontroller = Get.put(LocalController());
    SizeConfig.init(context);
    return GetMaterialApp(
      theme: ThemeData(fontFamily: AppFonts.inter),
      title: 'Ai Story Writer',
      translations: AppTranslations(),
      locale: Locale(localcontroller.selectedlngCode.value),

      fallbackLocale: Locale('en'),
      home: SplashScView(),
    );
  }
}
