// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // New Plugin

// class WordToPdfTestScreen extends StatefulWidget {
//   const WordToPdfTestScreen({super.key});

//   @override
//   State<WordToPdfTestScreen> createState() => _WordToPdfTestScreenState();
// }

// class _WordToPdfTestScreenState extends State<WordToPdfTestScreen> {
//   // MethodChannel ka naam wahi rakhein jo Swift code mein hai
//   static const platform = MethodChannel('com.example.app/word_to_pdf');

//   String? _convertedPdfPath;
//   bool _isLoading = false;

//   Future<void> _pickAndConvert() async {
//     try {
//       // 1. Word File Select Karein
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['docx', 'doc'],
//       );

//       if (result != null && result.files.single.path != null) {
//         setState(() {
//           _isLoading = true;
//           _convertedPdfPath = null;
//         });

//         String inputPath = result.files.single.path!;

//         // 2. Output Path set karein (Documents folder)
//         final directory = await getApplicationDocumentsDirectory();
//         String fileName =
//             "Converted_${DateTime.now().millisecondsSinceEpoch}.pdf";
//         String outputPath = "${directory.path}/$fileName";

//         // 3. Native Swift function call karein
//         final String? finalPath = await platform.invokeMethod(
//           'convertWordToPdf',
//           {'inputPath': inputPath, 'outputPath': outputPath},
//         );

//         if (finalPath != null) {
//           setState(() {
//             _convertedPdfPath = finalPath;
//             _isLoading = false;
//           });
//         } else {
//           throw "Conversion failed on iOS side";
//         }
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showError("Error: $e");
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Word to PDF Tester"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Center(
//         child: _isLoading
//             ? const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 20),
//                   Text("Converting... Please wait (2-3 sec)"),
//                 ],
//               )
//             : _convertedPdfPath == null
//             ? const Text("Select a Word file to start conversion")
//             : SfPdfViewer.file(File(_convertedPdfPath!)), // Modern PDF Viewer
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _isLoading ? null : _pickAndConvert,
//         label: const Text("Pick & Convert"),
//         icon: const Icon(Icons.picture_as_pdf),
//       ),
//     );
//   }
// }
