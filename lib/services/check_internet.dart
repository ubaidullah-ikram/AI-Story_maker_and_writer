
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

// Internet Check Service
class InternetCheckService {
  static final Connectivity _connectivity = Connectivity();

  // Check internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet)) {
        return true;
      }
      return false;
    } catch (e) {
      log('Internet check error: $e');
      return false;
    }
  }}