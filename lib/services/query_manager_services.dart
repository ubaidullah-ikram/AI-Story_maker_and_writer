import 'dart:developer';
import 'package:ai_story_writer/services/remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QueryManager {
  static const String _queryKey = 'user_queries';
  static const String _installedKey = 'is_installed';

  /// Call this when app starts (splash / main)
  static Future<void> initialize() async {
    log('QueryManager → initialize() called');

    final prefs = await SharedPreferences.getInstance();
    final isInstalled = prefs.getBool(_installedKey) ?? false;

    log('QueryManager → isInstalled = $isInstalled');

    if (!isInstalled) {
      // First install
      await prefs.setInt(_queryKey, RemoteConfigService().free_limit_queries);
      await prefs.setBool(_installedKey, true);

      log('QueryManager → First install detected');
      log('QueryManager → 3 queries assigned');
    } else {
      final queries = prefs.getInt(_queryKey) ?? 0;
      log('QueryManager → App already installed');
      log('QueryManager → Existing queries = $queries');
    }
  }

  static Future<void> setQueries(int newQueries) async {
    final prefs = await SharedPreferences.getInstance();

    log('QueryManager → setQueries() called');
    log('QueryManager → New queries = $newQueries');

    await prefs.setInt(_queryKey, newQueries);

    log('QueryManager → Queries updated successfully');
  }

  /// Downgrade user to FREE plan queries (when PRO expires)
  /// Downgrade user to FREE plan (only if already initialized)
  static Future<void> downgradeToFreeIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();

    log('QueryManager → downgradeToFreeIfNeeded() called');

    final isInstalled = prefs.getBool(_installedKey) ?? false;

    // agar first launch hy toh yeh fn kuch na kry
    if (!isInstalled) {
      log('QueryManager → User not initialized yet → skipping downgrade');
      return;
    }

    final currentQueries = prefs.getInt(_queryKey);

    // agar queries already set hain toh overwrite na kro
    if (currentQueries != null) {
      log('QueryManager → Queries already exist = $currentQueries');
      log('QueryManager → No reset required');
      return;
    }

    final freeQueries = RemoteConfigService().free_limit_queries;

    await prefs.setInt(_queryKey, freeQueries);

    log('QueryManager → User downgraded to FREE');
    log('QueryManager → Free queries assigned = $freeQueries');
  }

  /// Get remaining queries
  static Future<int> getRemainingQueries() async {
    final prefs = await SharedPreferences.getInstance();
    final queries = prefs.getInt(_queryKey) ?? 0;

    log('QueryManager → getRemainingQueries() = $queries');

    return queries;
  }

  /// Use / deduct 1 query
  static Future<bool> useQuery() async {
    final prefs = await SharedPreferences.getInstance();
    int queries = prefs.getInt(_queryKey) ?? 0;

    log('QueryManager → useQuery() called');
    log('QueryManager → Current queries = $queries');

    if (queries > 0) {
      queries--;
      await prefs.setInt(_queryKey, queries);

      log('QueryManager → Query used successfully');
      log('QueryManager → Remaining queries = $queries');

      return true;
    }

    log('QueryManager → ❌ No queries left');
    return false;
  }

  /// Optional: reset manually (testing / logout)
  static Future<void> resetQueries() async {
    log('QueryManager → resetQueries() called');

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queryKey);
    await prefs.remove(_installedKey);

    log('QueryManager → Queries & install flag cleared');
  }
}
