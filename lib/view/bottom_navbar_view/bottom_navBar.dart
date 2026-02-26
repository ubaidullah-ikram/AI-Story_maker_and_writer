
// import 'package:ai_story_writer/constant/app_Strings.dart';
// import 'package:ai_story_writer/res/app_colors/app_colors.dart';
// import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
// import 'package:ai_story_writer/res/app_images/app_images.dart';
// import 'package:ai_story_writer/res/setting_screen/setting_sc.dart';
// import 'package:ai_story_writer/res/your_story_history/history_view.dart';
// import 'package:ai_story_writer/view/home_screen/home_screen.dart';
// import 'package:ai_story_writer/view_model/home_view_model/home_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class BottomBarView extends StatefulWidget {
//   const BottomBarView({super.key});

//   @override
//   State<BottomBarView> createState() => _BottomBarViewState();
// }

// class _BottomBarViewState extends State<BottomBarView> {
//   final List screens = [HomeScreen(), HistoryView(), SettingScreen()];

//   final List unSelected = [
//     AppImages.home_icon,
//     AppImages.history,
//     AppImages.setting,
//   ];

//   final List selected = [
//     AppImages.home_fill,
//     AppImages.history_fill,
//     AppImages.setting_fill,
//   ];

//   HomeController _homeController = Get.put(HomeController());
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_homeController.bottomBarIndex.value == 0) {
//           // showExitBottomSheet(context);
//         } else {
//           _homeController.bottomBarIndex.value = 0;
//         }
//         return false;
//       },
//       child: Scaffold(backgroundColor: Appcolor.scaffoldbgColor,
//         body: Obx(() => screens[_homeController.bottomBarIndex.value]),

//         /// Bottom Navigation
//         bottomNavigationBar: Theme(
//           data: ThemeData(
//             splashColor: Colors.transparent, // ripple color remove
//             highlightColor: Colors.transparent, // long-press highlight remove
//             hoverColor: Colors.transparent, // desktop/web hover bhi hata do
//           ),
//           child: Obx(
//             () => BottomNavigationBar(
//               currentIndex: _homeController.bottomBarIndex.value,
//               backgroundColor: Appcolor.tileBackground,
//               selectedLabelStyle: TextStyle(fontFamily: AppFonts.inter),
//               unselectedLabelStyle: TextStyle(fontFamily: AppFonts.inter),
//               selectedItemColor: Colors.white,
//               unselectedItemColor: Colors.grey,
//               onTap: (index) {
//                 // setState(() {
//                 _homeController.bottomBarIndex.value = index;
//                 // });
//               },
//               items: [
//                 BottomNavigationBarItem(
//                   icon: Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Image.asset(unSelected[0], height: 24),
//                   ),
//                   activeIcon: Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Image.asset(selected[0], height: 24),
//                   ),
//                   label: "Dahsboard".tr,
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Image.asset(unSelected[1], height: 24),
//                   ),
//                   activeIcon: Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Image.asset(selected[1], height: 24),
//                   ),
//                   label: "Your Stories".tr,
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Image.asset(unSelected[2], height: 24),
//                   ),
//                   activeIcon: Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Image.asset(selected[2], height: 24),
//                   ),
//                   label: "Settings".tr,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:ai_story_writer/constant/app_Strings.dart';
import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_images/app_images.dart';
import 'package:ai_story_writer/res/setting_screen/setting_sc.dart';
import 'package:ai_story_writer/res/your_story_history/history_view.dart';
import 'package:ai_story_writer/view/home_screen/home_screen.dart';
import 'package:ai_story_writer/view_model/home_view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Add this
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  final List screens = [HomeScreen(), HistoryView(), SettingScreen()];

  final List unSelected = [
    AppImages.home_icon,
    AppImages.history,
    AppImages.setting,
  ];

  final List selected = [
    AppImages.home_fill,
    AppImages.history_fill,
    AppImages.setting_fill,
  ];

  HomeController _homeController = Get.put(HomeController());
  
  // ✅ Double back press ke liye variables
  DateTime? lastBackPressTime;
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_homeController.bottomBarIndex.value == 0) {
          // Home screen pe hai, double back press check karo
          final now = DateTime.now();
          
          if (lastBackPressTime == null || 
              now.difference(lastBackPressTime!) > Duration(seconds: 2)) {
            // Pehli baar back press ya 2 second se zyada time ho gaya
            lastBackPressTime = now;
            Fluttertoast.showToast(msg:      'Press again to exit app'.tr,);
            // Toast dikhao
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       'Press again to exit app',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     backgroundColor: Appcolor.tileBackground,
            //     duration: Duration(seconds: 2),
            //     behavior: SnackBarBehavior.floating,
            //     margin: EdgeInsets.all(16),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // );
            return false; // App exit nahi karo
          }
          
          // Dusri baar back press within 2 seconds - app exit karo
          SystemNavigator.pop(); // ✅ App exit
          return true;
        } else {
          // Other screens pe hai, home screen pe jao
          _homeController.bottomBarIndex.value = 0;
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Appcolor.scaffoldbgColor,
        body: Obx(() => screens[_homeController.bottomBarIndex.value]),

        /// Bottom Navigation
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: Obx(
            () => BottomNavigationBar(
              currentIndex: _homeController.bottomBarIndex.value,
              backgroundColor: Appcolor.tileBackground,
              selectedLabelStyle: TextStyle(fontFamily: AppFonts.inter),
              unselectedLabelStyle: TextStyle(fontFamily: AppFonts.inter),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                _homeController.bottomBarIndex.value = index;
              },
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(unSelected[0], height: 24),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(selected[0], height: 24),
                  ),
                  label: "Dashboard".tr,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(unSelected[1], height: 24),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(selected[1], height: 24),
                  ),
                  label: "Your Stories".tr,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(unSelected[2], height: 24),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(selected[2], height: 24),
                  ),
                  label: "Settings".tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}