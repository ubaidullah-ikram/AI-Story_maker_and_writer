// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';

// import 'package:ai_story_writer/res/app_colors/app_colors.dart';
// import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
// import 'package:ai_story_writer/res/app_images/app_images.dart';
// import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
// import 'package:ai_story_writer/services/admanage_service.dart';
// import 'package:ai_story_writer/services/remote_config.dart';
// import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_md/flutter_md.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:in_app_review/in_app_review.dart';
// import 'package:path_provider/path_provider.dart';

// import 'package:share_plus/share_plus.dart';
// import 'package:media_store_plus/media_store_plus.dart';

// class ResultScView extends StatefulWidget {
//   String? resultText;
//   ResultScView({Key? key, this.resultText}) : super(key: key);

//   @override
//   State<ResultScView> createState() => _ResultScViewState();
// }

// class _ResultScViewState extends State<ResultScView> {
//   var outputController = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     showRatingPrompt();
//     outputController.text = widget.resultText ?? "";

//     if (!Get.find<ProScreenController>().isUserPro.value) {
//       if (Platform.isIOS) {
//         if (RemoteConfigService().native_ad_for_IOS) {
//           loadAd();
//         }
//       } else {
//         if (RemoteConfigService().native_ad_for_android) {
//           loadAd();
//         }
//       }
//     }
//   }

//   Future<void> showRatingPrompt() async {
//     final InAppReview inAppReview = InAppReview.instance;

//     if (await inAppReview.isAvailable()) {
//       inAppReview.requestReview(); // Native App Store / Play Store popup
//     } else {
//       inAppReview.openStoreListing(
//         appStoreId: 'YOUR_IOS_APP_ID', // iOS only
//         microsoftStoreId: null,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Appcolor.scaffoldbgColor,

//       body: Stack(
//         children: [
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Column(
//                 children: [
//                   // Header
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12.0,
//                       vertical: 12.0,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           icon: const Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Text(
//                           'Result'.tr,
//                           style: TextStyle(
//                             fontFamily: AppFonts.inter,
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Scrollable content
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 10),
//                         _buildTextInput(),
//                         const SizedBox(height: 24),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Container(
//                               height: 36,
//                               width: 48,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50),
//                                 color: Appcolor.tileBackground,
//                                 border: Border.all(color: Color(0xff34343C)),
//                               ),
//                               child: IconButton(
//                                 icon: Icon(
//                                   isEditing ? Icons.check : Icons.edit,
//                                   color: Colors.white,
//                                   size: 18,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     isEditing = !isEditing;
//                                   });
//                                 },
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             Container(
//                               height: 36,
//                               width: 48,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50),
//                                 color: Appcolor.tileBackground,
//                                 border: Border.all(
//                                   color: const Color(0xff34343C),
//                                 ),
//                               ),
//                               child: TextButton(
//                                 onPressed: () {
//                                   Clipboard.setData(
//                                     ClipboardData(
//                                       text: outputController.text.toString(),
//                                     ),
//                                   );
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                         "Text copied to clipboard!".tr,
//                                       ),
//                                     ),
//                                   );
//                                   // TODO: Paste logic
//                                 },
//                                 child: Image.asset(
//                                   AppImages.copyIcon,
//                                   height: 20,
//                                   width: 20,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             Container(
//                               height: 36,
//                               width: 48,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50),
//                                 color: Appcolor.tileBackground,
//                                 border: Border.all(
//                                   color: const Color(0xff34343C),
//                                 ),
//                               ),
//                               child: TextButton(
//                                 onPressed: () async {
//                                   await SharePlus.instance.share(
//                                     ShareParams(
//                                       text: outputController.text.toString(),
//                                     ),
//                                   );
//                                   // TODO: Paste logic
//                                 },
//                                 child: Image.asset(
//                                   AppImages.shareIcon,
//                                   height: 20,
//                                   width: 20,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             Container(
//                               height: 36,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50),
//                                 color: Appcolor.tileBackground,
//                                 border: Border.all(
//                                   color: const Color(0xff34343C),
//                                 ),
//                               ),
//                               child: TextButton.icon(
//                                 onPressed: () {
//                                   saveTextFile(
//                                     outputController.text.toString(),
//                                   );
//                                 },
//                                 icon: Image.asset(
//                                   AppImages.downloadIcon,
//                                   height: 20,
//                                   width: 20,
//                                 ),
//                                 label: Text(
//                                   'Donwload'.tr,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Spacer(),
//                         _isLoaded && _nativeAd != null
//                             ? Container(
//                                 margin: const EdgeInsets.symmetric(vertical: 8),
//                                 height: 120,
//                                 child: AdWidget(ad: _nativeAd!),
//                               )
//                             : SizedBox.shrink(),

//                         // const SizedBox(height: 32),
//                         _buildGenerateButton(),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Blur effect
//           Positioned(
//             top: -100,
//             right: -10,
//             child: IgnorePointer(
//               child: ImageFiltered(
//                 imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
//                 child: Container(
//                   height: 300,
//                   width: 300,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: RadialGradient(
//                       colors: [
//                         Appcolor.themeColor.withOpacity(0.20),
//                         Appcolor.themeColor.withOpacity(0.01),
//                       ],
//                       radius: 0.7,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   bool isEditing = false;
//   Widget _buildTextInput() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Appcolor.tileBackground,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Color(0xff34343C), width: 1),
//       ),
//       height: 300,
//       child: Stack(
//         children: [
//           Container(
//             height: 280,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: isEditing
//                   ? TextField(
//                       controller: outputController,
//                       maxLines: null,
//                       expands: true,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Edit your text...",
//                         hintStyle: TextStyle(color: Colors.grey),
//                       ),
//                     )
//                   : SingleChildScrollView(
//                       child: MarkdownTheme(
//                         data: MarkdownThemeData(
//                           textStyle: TextStyle(
//                             color: Colors.white,
//                             height: 1.35,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           h1Style: TextStyle(
//                             fontSize: 22.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           h2Style: TextStyle(
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           quoteStyle: TextStyle(
//                             fontSize: 12.0,
//                             fontStyle: FontStyle.italic,
//                             color: Colors.white,
//                           ),
//                           // Handle link taps
//                           onLinkTap: (title, url) {
//                             print('Tapped link: $title -> $url');
//                           },
//                           // Filter blocks (e.g., exclude images)
//                           // blockFilter: (block) => block is! MD$Image,
//                           // Filter spans (e.g., exclude certain styles)
//                           spanFilter: (span) =>
//                               !span.style.contains(MD$Style.spoiler),
//                         ),
//                         child: MarkdownWidget(
//                           markdown: Markdown.fromString(
//                             outputController.text.toString(),
//                           ),
//                         ),
//                       ),
//                     ),
//             ),
//             // child: TextField(controller:outputController ,
//             //   maxLines: null,
//             //   expands: true,readOnly: true,
//             //   style: TextStyle(
//             //     color: Colors.white,
//             //     fontSize: 16,
//             //     fontFamily: AppFonts.inter,
//             //   ),
//             //   decoration: InputDecoration(
//             //     hintText: 'Describe your topic...',
//             //     hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
//             //     border: InputBorder.none,
//             //     contentPadding: EdgeInsets.all(20),
//             //   ),
//             // ),
//           ),
//           Positioned(
//             bottom: 5,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Word Generated: ${outputController.text.trim().split(RegExp(r'\s+')).length}',
//                   style: TextStyle(
//                     fontFamily: AppFonts.inter,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGenerateButton() {
//     return GestureDetector(
//       onTap: () {
//         Get.back();
//       },
//       child: Container(
//         height: SizeConfig.h(50),
//         decoration: BoxDecoration(
//           color: Appcolor.themeColor,
//           borderRadius: BorderRadius.circular(50),
//         ),
//         width: double.infinity,

//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Regenerate'.tr,
//               style: TextStyle(
//                 fontFamily: AppFonts.inter,
//                 color: Colors.white,
//                 fontSize: SizeConfig.sp(16),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   NativeAd? _nativeAd;
//   bool _isLoaded = false;

//   void loadAd() {
//     _nativeAd = NativeAd(
//       adUnitId: AdIds.nativeAdId,
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           log('native ad loaded.');
//           setState(() {
//             _isLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           log('native ad failedToLoad: $error');
//           ad.dispose();
//         },
//         onAdClicked: (ad) {},
//         onAdImpression: (ad) {},
//         onAdClosed: (ad) {},
//         onAdOpened: (ad) {},
//         onAdWillDismissScreen: (ad) {},
//         onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
//       ),
//       request: const AdRequest(),
//       nativeTemplateStyle: NativeTemplateStyle(
//         templateType: TemplateType.small,
//       ),
//     )..load();
//   }

//   /// Save TXT File - iOS & Android Compatible
//   Future<void> saveTextFile(String text) async {
//     try {
//       final fileName = "text_${DateTime.now().millisecondsSinceEpoch}.txt";

//       if (Platform.isAndroid) {
//         // Android: Use media_store_plus
//         await MediaStore.ensureInitialized();
//         MediaStore.appFolder = "ai_story_writter";

//         final tempDir = await getTemporaryDirectory();
//         final tempFile = File('${tempDir.path}/$fileName');

//         await tempFile.writeAsString(text);

//         await MediaStore().saveFile(
//           tempFilePath: tempFile.path,
//           dirType: DirType.download,
//           dirName: DirName.download,
//           relativePath: "ai_story_writter/TextFiles",
//         );

//         if (await tempFile.exists()) await tempFile.delete();
//         Fluttertoast.showToast(msg: 'Saved to files'.tr);
//       } else if (Platform.isIOS) {
//         // iOS: Save to app documents & share
//         final directory = await getApplicationDocumentsDirectory();
//         final filePath = '${directory.path}/$fileName';
//         final file = File(filePath);

//         await file.writeAsString(text);

//         // Share file using share_plus
//         await Share.shareXFiles(
//           [XFile(filePath)],
//           // text: 'Save TXT file',
//         );

//         // Fluttertoast.showToast(msg: 'TXT file ready to save!');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: Please try again'.tr);

//       log('Error saving TXT file: $e');
//     } finally {}
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/res/custom_rating.dart';
import 'package:ai_story_writer/services/admanage_service.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/view/result_view/dmy.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_saver/file_saver.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:printing/printing.dart';

class ResultScView extends StatefulWidget {
  String? resultText;
  ResultScView({Key? key, this.resultText}) : super(key: key);

  @override
  State<ResultScView> createState() => _ResultScViewState();
}

class _ResultScViewState extends State<ResultScView> {
  var outputController = TextEditingController();

  // Text-to-Speech
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    showRatingPrompt();
    outputController.text = widget.resultText ?? "";
    initTts();
  }

  // Future<void> _initTts() async {
  //   // iOS specific settings
  //   if (Platform.isIOS) {
  //     await flutterTts.setSharedInstance(true);
  //     await flutterTts.setIosAudioCategory(
  //       IosTextToSpeechAudioCategory.ambient,
  //       [
  //         IosTextToSpeechAudioCategoryOptions.allowBluetooth,
  //         IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
  //         IosTextToSpeechAudioCategoryOptions.mixWithOthers,
  //       ],
  //       IosTextToSpeechAudioMode.voicePrompt,
  //     );
  //   }

  //   await flutterTts.setLanguage("en-US");
  //   await flutterTts.setSpeechRate(Platform.isIOS ? 0.4 : 0.5);
  //   await flutterTts.setVolume(1.0);
  //   await flutterTts.setPitch(1.0);

  //   flutterTts.setCompletionHandler(() {
  //     setState(() {
  //       isSpeaking = false;
  //     });
  //   });

  //   flutterTts.setErrorHandler((msg) {
  //     log('TTS Error: $msg');
  //     setState(() {
  //       isSpeaking = false;
  //     });
  //   });
  // }
  void initTts() async {
    // Language set karna
    await flutterTts.setLanguage("en-US");

    // Speech speed (0.0 - 1.0)
    await flutterTts.setSpeechRate(0.5);

    // Pitch
    await flutterTts.setPitch(1.0);

    // Volume
    await flutterTts.setVolume(1.0);

    // iOS specific
    await flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ]);
  }

  Future<void> _speak() async {
    log('start speaking');
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    } else {
      String textToSpeak = outputController.text
          .replaceAll(RegExp(r'\*\*'), '')
          .replaceAll(RegExp(r'\*'), '')
          .replaceAll(RegExp(r'#{1,6}\s'), '')
          .replaceAll(RegExp(r'`'), '');

      if (textToSpeak.isNotEmpty) {
        setState(() {
          isSpeaking = true;
        });
        await flutterTts.speak(textToSpeak);
        log('Speaking: $textToSpeak');
      }
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    outputController.dispose();
    super.dispose();
  }

  Future<void> showRatingPrompt() async {
    await showCustomRatingDialog();
    // final InAppReview inAppReview = InAppReview.instance;

    // if (await inAppReview.isAvailable()) {
    //   inAppReview.requestReview();
    // } else {
    //   inAppReview.openStoreListing(
    //     appStoreId: 'YOUR_IOS_APP_ID',
    //     microsoftStoreId: null,
    //   );
    // }
  }

  // Report functionality
  Future<void> reportContent() async {
    final email = 'lohang097@gmail.com';
    final subject = 'Content Report - AI Story Writer';
    final body =
        'User Email: [User Email]\n\n'
        'Message: Please review this reported content\n\n'
        '--- Reported Content ---\n'
        '${outputController.text}\n'
        '--- End Content ---\n\n'
        'Thank you for keeping our community safe.';

    // Build email URI without queryParameters to avoid encoding issues
    final String emailUri =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    try {
      log('Attempting to launch: $emailUri');

      final Uri uri = Uri.parse(emailUri);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Fluttertoast.showToast(msg: 'Opening email...');
      } else {
        log('Cannot launch email');
        // Fallback: Copy to clipboard
        await Clipboard.setData(ClipboardData(text: email));
        Fluttertoast.showToast(msg: 'Email copied: $email');
      }
    } catch (e) {
      log('Error launching email: $e');
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Appcolor.scaffoldbgColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Result'.tr,
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
                  // TextButton(
                  //   onPressed: () {
                  //     Get.to(() => TtsExample());
                  //   },
                  //   child: Text('data'),
                  // ),
                  // Scrollable content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildTextInput(),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 36,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Appcolor.tileBackground,
                                border: Border.all(color: Color(0xff34343C)),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isEditing ? Icons.check : Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              height: 36,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Appcolor.tileBackground,
                                border: Border.all(
                                  color: const Color(0xff34343C),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: outputController.text.toString(),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Text copied to clipboard!".tr,
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  AppImages.copyIcon,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              height: 36,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Appcolor.tileBackground,
                                border: Border.all(
                                  color: const Color(0xff34343C),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  await SharePlus.instance.share(
                                    ShareParams(
                                      text: outputController.text.toString(),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  AppImages.shareIcon,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              height: 36,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Appcolor.tileBackground,
                                border: Border.all(
                                  color: const Color(0xff34343C),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  _showDownloadOptionsSheet();
                                },
                                child: Image.asset(
                                  AppImages.downloadIcon,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Speak Button
                            Container(
                              height: 36,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: isSpeaking
                                    ? Appcolor.themeColor.withOpacity(0.3)
                                    : Appcolor.tileBackground,
                                border: Border.all(
                                  color: isSpeaking
                                      ? Appcolor.themeColor
                                      : const Color(0xff34343C),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  _speak();
                                },
                                child: Icon(
                                  isSpeaking ? Icons.stop : Icons.volume_up,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Report Flag Icon
                            Container(
                              height: 36,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Appcolor.tileBackground,
                                border: Border.all(
                                  color: const Color(0xff34343C),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  reportContent();
                                },
                                child: Icon(
                                  Icons.flag,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),

                        // _isLoaded && _nativeAd != null
                        //     ? Container(
                        //         margin: const EdgeInsets.symmetric(vertical: 8),
                        //         height: 120,
                        //         child: AdWidget(ad: _nativeAd!),
                        //       )
                        //     : SizedBox.shrink(),
                        _buildGenerateButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
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

  bool isEditing = false;

  // Word count helper
  int _getWordCount() {
    if (outputController.text.trim().isEmpty) return 0;
    return outputController.text.trim().split(RegExp(r'\s+')).length;
  }

  // Reading time estimation (average 200 words per minute)
  String _getReadingTime() {
    int words = _getWordCount();
    if (words == 0) return '0 min';
    int minutes = (words / 200).ceil();
    if (minutes < 1) return '< 1 min';
    if (minutes == 1) return '1 min';
    return '$minutes mins';
  }

  Widget _buildTextInput() {
    return Container(
      decoration: BoxDecoration(
        color: Appcolor.tileBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff34343C), width: 1),
      ),
      height: Get.height * 0.55,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: isEditing
                ? SingleChildScrollView(
                    child: TextField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                      controller: outputController,
                      maxLines: null,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Edit your text...",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 23.0),
                      child: MarkdownTheme(
                        data: MarkdownThemeData(
                          textStyle: TextStyle(
                            color: Colors.white,
                            height: 1.35,
                            fontWeight: FontWeight.w400,
                          ),
                          h1Style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          h2Style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          quoteStyle: TextStyle(
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                          onLinkTap: (title, url) {
                            print('Tapped link: $title -> $url');
                          },
                          spanFilter: (span) =>
                              !span.style.contains(MD$Style.spoiler),
                        ),
                        child: MarkdownWidget(
                          markdown: Markdown.fromString(
                            outputController.text.toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Appcolor.scaffoldbgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Words:".tr +
                            ' ${_getWordCount()} • ' +
                            "Reading:".tr +
                            ' ${_getReadingTime()}',
                        style: TextStyle(
                          fontFamily: AppFonts.inter,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        height: SizeConfig.h(50),
        decoration: BoxDecoration(
          color: Appcolor.themeColor,
          borderRadius: BorderRadius.circular(50),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Regenerate'.tr,
              style: TextStyle(
                fontFamily: AppFonts.inter,
                color: Colors.white,
                fontSize: SizeConfig.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NativeAd? _nativeAd;
  // bool _isLoaded = false;

  // void loadAd() {
  //   _nativeAd = NativeAd(
  //     adUnitId: AdIds.nativeAdId,
  //     listener: NativeAdListener(
  //       onAdLoaded: (ad) {
  //         log('native ad loaded.');
  //         setState(() {
  //           _isLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         log('native ad failedToLoad: $error');
  //         ad.dispose();
  //       },
  //       onAdClicked: (ad) {},
  //       onAdImpression: (ad) {},
  //       onAdClosed: (ad) {},
  //       onAdOpened: (ad) {},
  //       onAdWillDismissScreen: (ad) {},
  //       onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
  //     ),
  //     request: const AdRequest(),
  //     nativeTemplateStyle: NativeTemplateStyle(
  //       templateType: TemplateType.small,
  //     ),
  //   )..load();
  // }

  Future<void> saveTextFile(String text) async {
    try {
      final fileName = "text_${DateTime.now().millisecondsSinceEpoch}.txt";

      if (Platform.isAndroid) {
        await MediaStore.ensureInitialized();
        MediaStore.appFolder = "ai_story_writter";

        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');

        await tempFile.writeAsString(text);

        await MediaStore().saveFile(
          tempFilePath: tempFile.path,
          dirType: DirType.download,
          dirName: DirName.download,
          relativePath: "ai_story_writter/TextFiles",
        );

        log('file downloaded to: ${tempFile.path}');
        if (await tempFile.exists()) await tempFile.delete();
        Fluttertoast.showToast(msg: 'Saved to files'.tr);
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        await file.writeAsString(text);

        await file.writeAsString(text);
        final result = await Share.shareXFiles([XFile(filePath)]);

        if (result.status == ShareResultStatus.success) {
          Fluttertoast.showToast(msg: 'Saved to files'.tr);
        } else {
          // Fluttertoast.showToast(msg: 'Sharing cancelled'.tr);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: Please try again'.tr);
      log('Error saving TXT file: $e');
    }
  }

  // Download Options Bottom Sheet
  void _showDownloadOptionsSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Appcolor.scaffoldbgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: const Color(0xff34343C)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Download As'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.inter,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose format to download'.tr,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontFamily: AppFonts.inter,
              ),
            ),
            const SizedBox(height: 24),
            // Download options
            Row(
              children: [
                Expanded(
                  child: _buildDownloadOption(
                    icon: Icons.description_rounded,
                    title: 'Text File'.tr,
                    subtitle: '.txt',
                    color: Colors.blue,
                    onTap: () {
                      Get.back();
                      saveTextFile(outputController.text);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDownloadOption(
                    icon: Icons.picture_as_pdf_rounded,
                    title: 'PDF File'.tr,
                    subtitle: '.pdf',
                    color: Colors.red,
                    onTap: () {
                      Get.back();
                      exportToPdf();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDownloadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Appcolor.tileBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.inter,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontFamily: AppFonts.inter,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> exportToPdf() async {
    try {
      final font = await PdfGoogleFonts.nunitoRegular();
      final fontBold = await PdfGoogleFonts.nunitoBold();

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
            pw.Text(
              "AI Story Generator",
              style: pw.TextStyle(font: fontBold, fontSize: 24),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              outputController.text,
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      final fileName = "AI_Story_${DateTime.now().millisecondsSinceEpoch}.pdf";

      if (Platform.isAndroid) {
        // ✅ ANDROID DIRECT DOWNLOAD SAVE
        await MediaStore.ensureInitialized();
        MediaStore.appFolder = "ai_story_writer";

        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');

        await tempFile.writeAsBytes(bytes);

        await MediaStore().saveFile(
          tempFilePath: tempFile.path,
          dirType: DirType.download,
          dirName: DirName.download,
          relativePath: "ai_story_writer/PDFs",
        );

        if (await tempFile.exists()) {
          await tempFile.delete();
        }

        Fluttertoast.showToast(msg: 'PDF saved to Downloads'.tr);
      } else if (Platform.isIOS) {
        // ✅ iOS SHARE SHEET
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        await file.writeAsBytes(bytes);

        final result = await Share.shareXFiles([XFile(filePath)]);

        if (result.status == ShareResultStatus.success) {
          Fluttertoast.showToast(msg: 'PDF exported successfully'.tr);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error creating PDF'.tr);
      print("Error: $e");
    }
  }
  // Future<void> exportToPdf() async {
  //   try {
  //     final font = await PdfGoogleFonts.nunitoRegular();
  //     final fontBold = await PdfGoogleFonts.nunitoBold();

  //     final pdf = pw.Document();

  //     String cleanText = outputController.text;

  //     pdf.addPage(
  //       pw.MultiPage(
  //         pageFormat: PdfPageFormat.a4,
  //         margin: const pw.EdgeInsets.all(40),
  //         build: (context) => [
  //           pw.Text(
  //             "AI Story Generator",
  //             style: pw.TextStyle(font: fontBold, fontSize: 24),
  //           ),
  //           pw.SizedBox(height: 20),
  //           pw.Text(cleanText, style: pw.TextStyle(font: font, fontSize: 12)),
  //         ],
  //       ),
  //     );

  //     final bytes = await pdf.save();

  //     final directory = await getTemporaryDirectory();
  //     final filePath =
  //         "${directory.path}/AI_Story_${DateTime.now().millisecondsSinceEpoch}.pdf";

  //     final file = File(filePath);
  //     await file.writeAsBytes(bytes);
  //     final result = await Share.shareXFiles([XFile(filePath)]);

  //     // Open Share Sheet (IMPORTANT FOR iOS)
  //     if (result.status == ShareResultStatus.success) {
  //       Fluttertoast.showToast(msg: 'PDF saved successfully!'.tr);
  //     } else {
  //       // Fluttertoast.showToast(msg: 'Sharing cancelled'.tr);
  //     }
  //     // await Share.shareXFiles([
  //     //   XFile(file.path),
  //     // ], text: "Here is your generated PDF");

  //     // Fluttertoast.showToast(msg: 'PDF saved successfully!'.tr);
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Error creating PDF: Please try again'.tr);

  //     print("Error: $e");
  //   }
  // }
}
