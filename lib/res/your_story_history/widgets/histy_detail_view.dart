import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_saver/file_saver.dart';
import 'package:printing/printing.dart';

class HistyDetailView extends StatefulWidget {
  String title;
  String text;
  HistyDetailView({Key? key, required this.text, required this.title})
    : super(key: key);

  @override
  State<HistyDetailView> createState() => _HistyDetailViewState();
}

class _HistyDetailViewState extends State<HistyDetailView> {
  @override
  void initState() {
    inputScreenController.text = widget.text;
    super.initState();
  }

  var inputScreenController = TextEditingController();

  // Word count helper
  int _getWordCount() {
    if (widget.text.trim().isEmpty) return 0;
    return widget.text.trim().split(RegExp(r'\s+')).length;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.scaffoldbgColor,
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
                      Expanded(
                        child: Text(
                          widget.title.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.inter,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                        const SizedBox(height: 16),
                        // Action Buttons Row
                        _buildActionButtons(),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.copy_rounded,
            label: 'Copy'.tr,
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.text));
              Fluttertoast.showToast(msg: 'Text copied!'.tr);
            },
          ),
        ),
        const SizedBox(width: 5),

        Expanded(
          child: _buildActionButton(
            icon: Icons.share_rounded,
            label: 'Share'.tr,
            onTap: () async {
              await SharePlus.instance.share(ShareParams(text: widget.text));
            },
          ),
        ),
        const SizedBox(width: 5),

        Expanded(
          child: _buildActionButton(
            icon: Icons.download_rounded,
            label: 'Download'.tr,
            onTap: () {
              _showDownloadOptionsSheet();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: Appcolor.tileBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xff34343C)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: AppFonts.inter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                    title: 'Text File',
                    subtitle: '.txt',
                    color: Colors.blue,
                    onTap: () {
                      Get.back();
                      _saveTextFile(widget.text);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDownloadOption(
                    icon: Icons.picture_as_pdf_rounded,
                    title: 'PDF File',
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

  Widget _buildTextInput() {
    return Stack(
      children: [
        Container(
          height: Get.height * 0.7,
          decoration: BoxDecoration(
            color: Appcolor.tileBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xff34343C), width: 1),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16,
                right: 16,
                bottom: 60,
              ),
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
                  spanFilter: (span) => !span.style.contains(MD$Style.spoiler),
                ),
                child: MarkdownWidget(
                  markdown: Markdown.fromString(widget.text.toString()),
                ),
              ),
              //          Text(
              //   widget.text,
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 16,
              //     fontFamily: AppFonts.inter,
              //   ),
              // ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Appcolor.tileBackground,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: Color(0xff34343C), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.text_fields, color: Appcolor.themeColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  "Words:".tr + ' ${_getWordCount()}',
                  style: TextStyle(
                    fontFamily: AppFonts.inter,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                Container(width: 1, height: 14, color: Colors.grey[600]),
                const SizedBox(width: 16),
                Icon(Icons.schedule, color: Appcolor.themeColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  "Reading:".tr + ' ${_getReadingTime()}',
                  style: TextStyle(
                    fontFamily: AppFonts.inter,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Save Text File Function
  Future<void> _saveTextFile(String text) async {
    try {
      final fileName = "story_${DateTime.now().millisecondsSinceEpoch}.txt";

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

        if (await tempFile.exists()) await tempFile.delete();
        Fluttertoast.showToast(msg: 'Saved to files'.tr);
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        await file.writeAsString(text);
        final result = await Share.shareXFiles([XFile(filePath)]);

        if (result.status == ShareResultStatus.success) {
          Fluttertoast.showToast(msg: 'Saved to files'.tr);
        } else {
          // Fluttertoast.showToast(msg: 'Sharing cancelled'.tr);
        }
        // await Share.shareXFiles([XFile(filePath)]);

        // Fluttertoast.showToast(msg: 'Saved to files'.tr);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: Please try again'.tr);
      log('Error saving TXT file: $e');
    }
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
            pw.Text(widget.text, style: pw.TextStyle(font: font, fontSize: 12)),
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

  //     String cleanText = widget.text;

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

  //     // Open Share Sheet (IMPORTANT FOR iOS)
  //     final result = await Share.shareXFiles([XFile(filePath)]);

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
