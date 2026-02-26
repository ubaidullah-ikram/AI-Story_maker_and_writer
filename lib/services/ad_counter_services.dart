// // Ad Counter Service - reusable across all tools
// import 'package:shared_preferences/shared_preferences.dart';

// class AdCounterService {
//   static const String _counterKey = 'ad_show_counter';

//   // Get current counter value
//   static Future<int> getCounter() async {
//     final sp = await SharedPreferences.getInstance();
//     return sp.getInt(_counterKey) ?? 0;
//   }

//   // Increment counter
//   static Future<int> incrementCounter() async {
//     final sp = await SharedPreferences.getInstance();
//     final currentCount = sp.getInt(_counterKey) ?? 0;
//     final newCount = currentCount + 1;
//     await sp.setInt(_counterKey, newCount);
//     return newCount;
//   }

//   // Reset counter
//   static Future<void> resetCounter() async {
//     final sp = await SharedPreferences.getInstance();
//     await sp.setInt(_counterKey, 0);
//   }

//   // Check if ad should show and reset if matched
//   static Future<bool> checkAndResetIfMatched(int threshold) async {
//     final currentCount = await getCounter();
//     if (currentCount == threshold) {
//       await resetCounter();
//       return true;
//     }
//     return false;
//   }
// }
