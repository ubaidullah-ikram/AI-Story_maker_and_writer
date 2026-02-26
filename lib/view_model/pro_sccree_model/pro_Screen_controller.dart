import 'dart:developer';
import 'dart:io';
import 'package:ai_story_writer/services/query_manager_services.dart';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:ai_story_writer/services/revnue_cat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProScreenController extends GetxController {
  final isUserPro = false.obs;
  final products = <StoreProduct>[].obs;
  final isLoading = false.obs;

  late MyPurchaseCallbacks callbacks;

  @override
  void onInit() {
    super.onInit();
    callbacks = MyPurchaseCallbacks(controller: this);
    // RevenueCatHelper().initPlatformState();
    getProducts();
    checkProStatus();
  }

  getProducts() async {
    isLoading.value = true;
    log('🔍 Attempting to fetch products with IDs:');
    for (var id in RevenueCatHelper().productIdentifiers) {
      log('   - $id');
    }

    List<StoreProduct> fetchedProducts = await RevenueCatHelper().getProducts();

    // ✅ Sort products in the correct order: Monthly → Six Months → Yearly

    if (Platform.isAndroid) {
      fetchedProducts.sort((a, b) {
        int getOrder(String id) {
          // Lowercase compare karo for safety
          String lowerId = id.toLowerCase();

          if (lowerId.contains('weekly') || lowerId.contains('week')) return 0;
          if (lowerId.contains('monthly') || lowerId.contains('month'))
            return 1;
          if (lowerId.contains('yearly') || lowerId.contains('year')) return 2;

          return 3; // Unknown products last
        }

        return getOrder(a.identifier).compareTo(getOrder(b.identifier));
      });
    } else {
      fetchedProducts.sort((a, b) {
        int getOrder(String id) {
          if (id == "ai_story_weekly") return 0;
          if (id == "ai_story_monthly") return 1;
          if (id == "ai_story_yearly") return 2;
          return 3;
        }

        return getOrder(a.identifier).compareTo(getOrder(b.identifier));
      });
    }

    products.value = fetchedProducts;

    log('📦 Products fetched and sorted: ${products.length}');
    for (var product in products) {
      log('✅ Sorted Product:');
      log('   ID: ${product.identifier}');
      log('   Title: ${product.title}');
      log('   Price: ${product.priceString}');
      log('---');
    }

    if (products.isEmpty) {
      log('❌ NO PRODUCTS FETCHED - Check product IDs match RevenueCat!');
    }

    isLoading.value = false;
  }

  Future<void> checkProStatus() async {
    isUserPro.value = await RevenueCatHelper().checkSubscriptionStatus();
    log('✅ Pro Status Check: ${isUserPro.value}');
  }

  // ✅ Show platform-specific loading dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: CupertinoActivityIndicator(
                radius: 20,
                color: CupertinoColors.white,
              ),
            ),
          );
        } else {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text('Processing...'),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // ✅ Dismiss loading dialog
  void _dismissLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  buyProduct(StoreProduct product, BuildContext context) async {
    log('🛒 Selected Product ID: ${product.identifier}');
    log('🛒 Selected Product Title: ${product.title}');
    log('🛒 Selected Product Price: ${product.priceString}');

    // ✅ Show loading dialog
    _showLoadingDialog(context);

    try {
      await RevenueCatHelper().buyProduct(product, callbacks, context);
      // ✅ Recheck status after purchase
      await checkProStatus();
    } catch (e) {
      log('❌ Purchase Error: $e');
    } finally {
      // ✅ Dismiss loading dialog
      _dismissLoadingDialog(context);
    }
  }

  restorePurchase(BuildContext context) async {
    // ✅ Show loading dialog
    _showLoadingDialog(context);

    try {
      await RevenueCatHelper().restorePurchases(context, callbacks);
      // ✅ Recheck status after restore
      await checkProStatus();
    } catch (e) {
      log('❌ Restore Error: $e');
    } finally {
      // ✅ Dismiss loading dialog
      _dismissLoadingDialog(context);
    }
  }
}

class MyPurchaseCallbacks implements InAppCallback {
  final ProScreenController controller;
  MyPurchaseCallbacks({required this.controller});

  @override
  void onPuchaseExpired(BuildContext context) {
    Fluttertoast.showToast(msg: 'Subscription expired'.tr);
  }

  @override
  void onPurchaseCancelled(BuildContext context) {
    Fluttertoast.showToast(msg: 'Purchase cancelled'.tr);
  }

  @override
  void onPurchaseFailure(BuildContext context) {
    Fluttertoast.showToast(msg: 'Purchase failed'.tr);
  }

  @override
  void onPurchaseRestoreFailed(BuildContext context) {
    Fluttertoast.showToast(msg: 'Restore failed'.tr);
  }

  @override
  void onPurchaseSuccess(BuildContext context) async {
    log('💎 Purchase Success Callback Triggered');

    final prefs = await SharedPreferences.getInstance();

    // ✅ 1. Mark user as pro
    await prefs.setBool('is_user_pro', true);
    controller.isUserPro.value = true;

    // ✅ 3. Assign initial credits based on plan
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[RevenueCatHelper.entitlementIdentifier];

      if (entitlement != null && entitlement.isActive) {
        String productId = entitlement.productIdentifier;

        if (productId == "ai_story_weekly") {
          // credits = 30000;
          QueryManager.setQueries(RemoteConfigService().query_manager.weekly);
        } else if (productId == "ai_story_monthly") {
          QueryManager.setQueries(RemoteConfigService().query_manager.monthly);
        } else if (productId == "ai_story_yearly") {
          QueryManager.setQueries(RemoteConfigService().query_manager.yearly);
        }

        final expirationDate = entitlement.expirationDate;
        if (expirationDate != null) {
          await prefs.setString(
            'last_expiration_date',
            DateTime.parse(expirationDate).toIso8601String(),
          );
        }
      }
    } catch (e) {
      log('❌ Error assigning initial credits: $e');
    }

    log('💎 User upgraded to PRO successfully');
    Fluttertoast.showToast(msg: 'Purchase Successful!'.tr);

    Future.delayed(Duration(milliseconds: 500), () {
      Get.back();
    });
  }

  @override
  void onPurchasedRestored(BuildContext context) async {
    log('💎 Purchase Restored Callback Triggered');

    final prefs = await SharedPreferences.getInstance();

    // ✅ Mark user as pro
    await prefs.setBool('is_user_pro', true);
    controller.isUserPro.value = true;
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    EntitlementInfo? entitlement =
        customerInfo.entitlements.all[RevenueCatHelper.entitlementIdentifier];

    if (entitlement != null && entitlement.isActive) {
      String productId = entitlement.productIdentifier;

      if (productId == "ai_story_weekly") {
        // credits = 30000;
        QueryManager.setQueries(RemoteConfigService().query_manager.weekly);
      } else if (productId == "ai_story_monthly") {
        QueryManager.setQueries(RemoteConfigService().query_manager.monthly);
      } else if (productId == "ai_story_yearly") {
        QueryManager.setQueries(RemoteConfigService().query_manager.yearly);
      }

      final expirationDate = entitlement.expirationDate;
      if (expirationDate != null) {
        await prefs.setString(
          'last_expiration_date',
          DateTime.parse(expirationDate).toIso8601String(),
        );
      }
    }
    Fluttertoast.showToast(msg: 'Purchase restored successfully');

    Future.delayed(Duration(milliseconds: 500), () {
      Get.back();
    });
  }
}
