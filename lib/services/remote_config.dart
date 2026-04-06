import 'dart:convert';
import 'dart:io';

import 'package:ai_story_writer/model/all_query_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// initialize karna hoga app start mai
  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? const Duration(seconds: 5)
            : const Duration(hours: 2), // testing
      ),
    );

    await _remoteConfig.fetchAndActivate();
  }

  // ✅ Yahan apke console ke parameter key likho
  // String get welcomeText => _remoteConfig.getString('welcome_text');

  bool get banner_ad_for_android =>
      _remoteConfig.getBool('banner_ad_for_android');
  String get apiKey => _remoteConfig.getString('api_key');
  int get force_update_version => _remoteConfig.getInt(
    Platform.isAndroid ? "force_update_for_android" : 'force_update_version',
  );
  bool get banner_add_for_IOS => _remoteConfig.getBool('banner_add_for_IOS');
  bool get inter_ad_for_IOS => _remoteConfig.getBool('inter_ad_for_IOS');
  bool get intersitial_ads_for_andiod =>
      _remoteConfig.getBool('intersitial_ads_for_andiod');
  bool get native_ad_for_android =>
      _remoteConfig.getBool('native_ad_for_android');
  bool get native_ad_for_IOS => _remoteConfig.getBool('native_ad_for_IOS');
  bool get open_ad_for_android => _remoteConfig.getBool('open_ad_for_android');
  bool get open_ad_for_IOS => _remoteConfig.getBool('open_ad_for_IOS');
  int get free_limit_queries => _remoteConfig.getInt('free_limit_queries');
  QuerymodelRemote get query_manager {
    final jsonString = _remoteConfig.getString('query_manager');
    return QuerymodelRemote.fromJson(json.decode(jsonString));
  }
}
