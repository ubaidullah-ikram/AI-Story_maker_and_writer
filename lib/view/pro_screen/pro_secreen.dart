// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';

// import 'package:ai_story_writer/res/app_colors/app_colors.dart';
// import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
// import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
// import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:purchases_flutter/models/store_product_wrapper.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ProScreen extends StatefulWidget {
//   const ProScreen({super.key});

//   @override
//   State<ProScreen> createState() => _ProScreenState();
// }

// class _ProScreenState extends State<ProScreen> {
//   // var apiController = Get.put(GeminiApiServiceController());
//   // String selectedPlan = 'Yearly';
//   int selectedSubscription = 1;
//   Future<void> _launchURL(String urlN) async {
//     final Uri url = Uri.parse(urlN); // jis URL par jana hy
//     await launchUrl(
//       url,
//       // mode: LaunchMode.externalApplication, // external browser khulega
//     );
//   }

//   var _proscreenController = Get.put(ProScreenController());
//   StoreProduct? products;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (_proscreenController.products.isNotEmpty) {
//       products = _proscreenController.products[2];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Appcolor.scaffoldbgColor,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: SizeConfig.h(50)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Go Premium'.tr,
//                   style: TextStyle(
//                     fontSize: SizeConfig.sp(25),
//                     fontFamily: AppFonts.inter,
//                     fontWeight: FontWeight.w700,

//                     color: Colors.white, // default black
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     height: 30,
//                     width: 30,
//                     child: Icon(Icons.close, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               'Unlock Everything.'.tr,
//               style: TextStyle(
//                 fontSize: SizeConfig.sp(25),
//                 fontFamily: AppFonts.inter,
//                 fontWeight: FontWeight.w700,

//                 color: Colors.white, // default black
//               ),
//             ),

//             SizedBox(height: SizeConfig.h(10)),
//             _buildBenefits(),

//             Obx(
//               () => Column(
//                 children: List.generate(_proscreenController.products.length, (
//                   index,
//                 ) {
//                   final isSelected = selectedPlanindex == index;
//                   var title = index == 0
//                       ? 'Weekly'
//                       : index == 1
//                       ? 'Monthly'
//                       : "Yearly";

//                   var subtitle = index == 0
//                       ? 'week'
//                       : index == 1
//                       ? 'month'
//                       : 'year';
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedPlanindex = index;
//                         products = _proscreenController.products[index];
//                       });
//                     },
//                     child: Stack(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.symmetric(vertical: 4),
//                           height: SizeConfig.isTablet
//                               ? SizeConfig.sp(122)
//                               : SizeConfig.h(72),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: SizeConfig.h(8),
//                                   vertical: SizeConfig.h(8),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? Color(0xffA068FF).withOpacity(0.1)
//                                       : Color(0xff1F1F1F),
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: isSelected
//                                         ? Color(0xffA068FF)
//                                         : Color(0xff393939)!,
//                                     width: isSelected ? 2 : 1,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     const SizedBox(width: 6),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             title.tr,
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.isTablet
//                                                   ? SizeConfig.sp(22)
//                                                   : SizeConfig.sp(15),
//                                               color: Colors.white,
//                                               fontFamily: AppFonts.inter,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 2),
//                                           Text(
//                                             "${_proscreenController.products[index].priceString}/${subtitle.tr}",
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.isTablet
//                                                   ? SizeConfig.sp(22)
//                                                   : SizeConfig.sp(13),
//                                               fontFamily: AppFonts.inter,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       width: 20,
//                                       height: 20,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                           color: isSelected
//                                               ? Color(0xffA068FF)
//                                               : Colors.grey[400]!,
//                                           width: 2,
//                                         ),
//                                         color: isSelected
//                                             ? Color(0xffA068FF)
//                                             : Colors.transparent,
//                                       ),
//                                       child: isSelected
//                                           ? const Icon(
//                                               Icons.circle,
//                                               size: 12,
//                                               color: Colors.black,
//                                             )
//                                           : null,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (index == 2)
//                           Positioned(
//                             top: SizeConfig.isTablet ? SizeConfig.h(12) : 0,
//                             right: SizeConfig.w(30),
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.pink[400],
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 '3 days free'.tr,
//                                 style: TextStyle(
//                                   fontFamily: AppFonts.inter,
//                                   color: Colors.white,
//                                   fontSize: SizeConfig.isTablet
//                                       ? SizeConfig.sp(22)
//                                       : SizeConfig.sp(12),
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),

//                     // child: _buildPlanCard(
//                     //   title,
//                     //   '${_proscreenController.products[index].priceString}/$subtitle',
//                     //   false,
//                     //   index,
//                     // ),
//                   );
//                 }),
//               ),
//             ),

//             SizedBox(height: SizeConfig.h(12)),
//             Spacer(),
//             _buildStartTrialButton(),
//             // Spacer(),
//             SizedBox(height: SizeConfig.h(12)),
//             Column(
//               children: [
//                 selectedPlanindex == 2
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.check_circle,
//                             color: Color(0xff00BA00),
//                             size: 18,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             "No Payment Now".tr,
//                             style: TextStyle(
//                               fontFamily: AppFonts.inter,
//                               fontSize: SizeConfig.isTablet
//                                   ? SizeConfig.sp(22)
//                                   : SizeConfig.sp(14),
//                               color: Color(0xff00BA00),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       )
//                     : SizedBox.shrink(),

//                 SizedBox(height: SizeConfig.h(4)),
//                 Text(
//                   "No Commitment. Cancel anytime".tr,
//                   style: TextStyle(
//                     fontSize: SizeConfig.isTablet
//                         ? SizeConfig.sp(22)
//                         : SizeConfig.sp(13),
//                     fontFamily: AppFonts.inter,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: SizeConfig.h(5)),
//                 Platform.isAndroid
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               _launchURL(
//                                 'https://pioneerdigital.tech/privacy-policy.html',
//                               );
//                             },
//                             child: Text(
//                               "Privacy Policy".tr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: SizeConfig.sp(12),
//                                 fontFamily: AppFonts.inter,
//                                 color: Colors.white,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                           Container(height: 15, width: 1, color: Colors.grey),
//                           GestureDetector(
//                             onTap: () {
//                               _launchURL(
//                                 'https://pioneerdigital.tech/terms-and-conditions.html',
//                               );
//                             },
//                             child: Text(
//                               "Terms & Condition".tr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: SizeConfig.sp(12),
//                                 decoration: TextDecoration.underline,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               _launchURL(
//                                 'https://pioneerdigital.tech/privacy-policy.html',
//                               );
//                             },
//                             child: Text(
//                               "Privacy Policy".tr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: SizeConfig.isTablet
//                                     ? SizeConfig.sp(22)
//                                     : SizeConfig.sp(12),
//                                 fontFamily: AppFonts.inter,
//                                 color: Colors.white,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                           Container(height: 15, width: 1, color: Colors.grey),

//                           GestureDetector(
//                             onTap: () {
//                               log('message');
//                               if (products != null) {
//                                 _proscreenController.restorePurchase(context);
//                               }
//                             },
//                             child: Container(
//                               // height: 20,
//                               child: Text(
//                                 "Restore".tr,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   decoration: TextDecoration.underline,
//                                   fontSize: SizeConfig.isTablet
//                                       ? SizeConfig.sp(22)
//                                       : SizeConfig.sp(12),
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(height: 15, width: 1, color: Colors.grey),
//                           GestureDetector(
//                             onTap: () {
//                               _launchURL(
//                                 'https://pioneerdigital.tech/terms-and-conditions.html',
//                               );
//                             },
//                             child: Text(
//                               "Terms & Condition".tr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: SizeConfig.isTablet
//                                     ? SizeConfig.sp(22)
//                                     : SizeConfig.sp(12),
//                                 decoration: TextDecoration.underline,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                 SizedBox(height: SizeConfig.h(20)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBenefits() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         gradient: LinearGradient(
//           colors: [Colors.white, Colors.white, Colors.white],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.05),
//         //     blurRadius: 10,
//         //     offset: const Offset(0, 2),
//         //   ),
//         // ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Row(
//           //   children: [
//           //     Text(
//           //       'BENEFITS'.tr,
//           //       style: TextStyle(
//           //         fontFamily: AppFonts.inter,
//           //         color: Color(0xffA068FF),
//           //         fontSize: 12,
//           //         fontWeight: FontWeight.w600,
//           //         letterSpacing: 0,
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           // const SizedBox(height: 16),
//           _buildBenefitItem('✓', "Unlimited Story Generation"),
//           const SizedBox(height: 12),
//           _buildBenefitItem('✓', "Write Longer & Detailed Essays"),
//           const SizedBox(height: 12),
//           _buildBenefitItem('✓', 'Advanced Script Writer'),
//           const SizedBox(height: 12),
//           _buildBenefitItem('✓', 'Unlock All Styles & Tones'),
//           const SizedBox(height: 12),
//           _buildBenefitItem('✓', 'No Word/Length Limit'),
//           const SizedBox(height: 12),
//           _buildBenefitItem('✓', 'Remove All Ads'),
//         ],
//       ),
//     );
//   }

//   Widget _buildBenefitItem(String icon, String text) {
//     return Row(
//       children: [
//         Icon(Icons.done, color: Color(0xffA068FF), size: 14),
//         const SizedBox(width: 12),
//         Text(
//           text.tr,
//           style: TextStyle(
//             fontSize: 14,
//             fontFamily: AppFonts.inter,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }

//   int selectedPlanindex = 2;

//   Widget _buildStartTrialButton() {
//     return GestureDetector(
//       onTap: () {
//         log("${products!}");
//         if (products != null) {
//           _proscreenController.buyProduct(products!, context);
//         }
//       },
//       child: Container(
//         width: double.infinity,
//         height: SizeConfig.sp(44),
//         decoration: BoxDecoration(
//           color: Color(0xffA068FF),
//           borderRadius: BorderRadius.circular(28),
//         ),
//         child: Center(
//           child: Text(
//             selectedPlanindex == 2
//                 ? 'Start your free trial'.tr
//                 : "Subscribe".tr,
//             style: TextStyle(
//               fontSize: SizeConfig.isTablet ? SizeConfig.sp(22) : 16,
//               fontFamily: AppFonts.inter,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:ai_story_writer/res/app_colors/app_colors.dart';
import 'package:ai_story_writer/res/app_fonts/app_fonts.dart';
import 'package:ai_story_writer/res/app_responsive/responsive_config.dart';
import 'package:ai_story_writer/view_model/pro_sccree_model/pro_Screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  int selectedSubscription = 1;

  Future<void> _launchURL(String urlN) async {
    final Uri url = Uri.parse(urlN);
    await launchUrl(url);
  }

  var _proscreenController = Get.put(ProScreenController());
  StoreProduct? products;
  int selectedPlanindex = 2;

  @override
  void initState() {
    super.initState();
    if (_proscreenController.products.isNotEmpty) {
      products = _proscreenController.products[2];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.scaffoldbgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.h(50)),
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Go Premium'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: SizeConfig.sp(25),
                          fontFamily: AppFonts.inter,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(5)),
                      Text(
                        'Unlock Everything'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: SizeConfig.sp(25),
                          fontFamily: AppFonts.inter,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    // decoration: BoxDecoration(
                    //   color: Colors.white.withOpacity(0.1),
                    //   borderRadius: BorderRadius.circular(8),
                    // ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(15)),
            // Benefits Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildBenefits(),
                    SizedBox(height: SizeConfig.h(20)),
                    // Subscription Plans
                    Obx(
                      () => Column(
                        children: List.generate(
                          _proscreenController.products.length,
                          (index) {
                            final isSelected = selectedPlanindex == index;
                            var title = index == 0
                                ? 'Weekly'
                                : index == 1
                                ? 'Monthly'
                                : "Yearly";

                            var subtitle = index == 0
                                ? 'week'
                                : index == 1
                                ? 'month'
                                : 'year';

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPlanindex = index;
                                  products =
                                      _proscreenController.products[index];
                                });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.h(12),
                                        vertical: SizeConfig.h(12),
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Color(0xffA068FF).withOpacity(0.1)
                                            : Color(0xff1F1F1F),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected
                                              ? Color(0xffA068FF)
                                              : Color(0xff393939),
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  title.tr,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize:
                                                        SizeConfig.isTablet
                                                        ? SizeConfig.sp(18)
                                                        : SizeConfig.sp(15),
                                                    color: Colors.white,
                                                    fontFamily: AppFonts.inter,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  "${_proscreenController.products[index].priceString}/${subtitle.tr}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize:
                                                        SizeConfig.isTablet
                                                        ? SizeConfig.sp(16)
                                                        : SizeConfig.sp(13),
                                                    fontFamily: AppFonts.inter,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected
                                                    ? Color(0xffA068FF)
                                                    : Colors.grey[400]!,
                                                width: 2,
                                              ),
                                              color: isSelected
                                                  ? Color(0xffA068FF)
                                                  : Colors.transparent,
                                            ),
                                            child: isSelected
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index == 2)
                                    Positioned(
                                      top: -2,
                                      right: 16,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.pink[400],
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          '3 days free'.tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: AppFonts.inter,
                                            color: Colors.white,
                                            fontSize: SizeConfig.isTablet
                                                ? SizeConfig.sp(12)
                                                : SizeConfig.sp(10),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Button and footer
            SizedBox(height: SizeConfig.h(12)),
            _buildStartTrialButton(),
            SizedBox(height: SizeConfig.h(12)),
            _buildFooterSection(),
            SizedBox(height: SizeConfig.h(15)),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefits() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBenefitItem('Unlimited Story Generation'),
          const SizedBox(height: 10),
          _buildBenefitItem('Write Longer & Detailed Essays'),
          const SizedBox(height: 10),
          _buildBenefitItem('Advanced Script Writer'),
          const SizedBox(height: 10),
          _buildBenefitItem('Unlock All Styles & Tones'),
          const SizedBox(height: 10),
          _buildBenefitItem('No Word/Length Limit'),
          const SizedBox(height: 10),
          _buildBenefitItem('Remove All Ads'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Row(
      children: [
        Icon(Icons.done_rounded, color: Color(0xffA068FF), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: SizeConfig.isTablet ? SizeConfig.sp(14) : 14,
              fontFamily: AppFonts.inter,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartTrialButton() {
    return GestureDetector(
      onTap: () {
        // log("${products!}");
        if (products != null) {
          _proscreenController.buyProduct(products!, context);
        }
      },
      child: Container(
        width: double.infinity,
        height: SizeConfig.sp(48),
        decoration: BoxDecoration(
          color: Color(0xffA068FF),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Text(
            selectedPlanindex == 2
                ? 'Start your free trial'.tr
                : "Subscribe".tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: SizeConfig.isTablet ? SizeConfig.sp(16) : 16,
              fontFamily: AppFonts.inter,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return Column(
      children: [
        if (selectedPlanindex == 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Color(0xff00BA00), size: 18),
                SizedBox(width: 8),
                Text(
                  "No Payment Now".tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.inter,
                    fontSize: SizeConfig.isTablet
                        ? SizeConfig.sp(14)
                        : SizeConfig.sp(12),
                    color: Color(0xff00BA00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

        Center(
          child: Text(
            "No Commitment. Cancel anytime".tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.isTablet
                  ? SizeConfig.sp(13)
                  : SizeConfig.sp(12),
              fontFamily: AppFonts.inter,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.h(8)),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            GestureDetector(
              onTap: () {
                _launchURL('https://pioneerdigital.tech/privacy-policy.html');
              },
              child: Text(
                "Privacy Policy".tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: SizeConfig.sp(11),
                  fontFamily: AppFonts.inter,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Platform.isAndroid
                ? SizedBox.shrink()
                : Text("|", style: TextStyle(color: Colors.grey)),
            Platform.isAndroid
                ? SizedBox.shrink()
                : GestureDetector(
                    onTap: () {
                      if (products != null) {
                        _proscreenController.restorePurchase(context);
                      }
                    },
                    child: Text(
                      "Restore".tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: SizeConfig.sp(11),
                        fontFamily: AppFonts.inter,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
            Platform.isAndroid
                ? SizedBox.shrink()
                : Text("|", style: TextStyle(color: Colors.grey)),
            GestureDetector(
              onTap: () {
                _launchURL(
                  'https://pioneerdigital.tech/terms-and-conditions.html',
                );
              },
              child: Text(
                "Terms & Condition".tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: SizeConfig.sp(11),
                  fontFamily: AppFonts.inter,
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
