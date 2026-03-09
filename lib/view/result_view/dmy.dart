// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class TtsExample extends StatefulWidget {
//   @override
//   _TtsExampleState createState() => _TtsExampleState();
// }

// class _TtsExampleState extends State<TtsExample> {
//   final FlutterTts flutterTts = FlutterTts();

//   @override
//   void initState() {
//     super.initState();
//     initTts();
//   }

//   void initTts() async {
//     // Language set karna
//     await flutterTts.setLanguage("en-US");

//     // Speech speed (0.0 - 1.0)
//     await flutterTts.setSpeechRate(0.5);

//     // Pitch
//     await flutterTts.setPitch(1.0);

//     // Volume
//     await flutterTts.setVolume(1.0);

//     // iOS specific
//     await flutterTts
//         .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
//           IosTextToSpeechAudioCategoryOptions.allowBluetooth,
//           IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
//         ]);
//   }

//   Future speak() async {
//     await flutterTts.speak("Hello, this is text to speech example.");
//   }

//   Future stop() async {
//     await flutterTts.stop();
//   }

//   @override
//   void dispose() {
//     flutterTts.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("TTS Example")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(onPressed: speak, child: Text("Speak")),
//           ElevatedButton(onPressed: stop, child: Text("Stop")),
//         ],
//       ),
//     );
//   }
// }
