import 'dart:collection';
import 'dart:developer';

/// Service to optimize Gemini API usage and reduce costs.
///
/// Key optimizations:
/// 1. Input text trimming & length limits
/// 2. Response caching (avoid duplicate API calls)
/// 3. Client-side input validation (avoid wasting tokens on gibberish)
/// 4. Token-efficient generationConfig
/// 5. Prompt compression utilities
class GeminiOptimizerService {
  static final GeminiOptimizerService _instance =
      GeminiOptimizerService._internal();
  factory GeminiOptimizerService() => _instance;
  GeminiOptimizerService._internal();

  // ─── Input Limits ───────────────────────────────────────────────
  static const int maxTopicLength = 500; // topic/description fields
  static const int maxStoryRewriteLength = 3000; // rewrite story input
  static const int maxKeywordsLength = 200; // keywords field
  static const int maxAdditionalDetailsLength = 500; // extra details

  // ─── Cache (LRU-style, max 20 entries) ──────────────────────────
  static const int _maxCacheSize = 20;
  final LinkedHashMap<String, _CachedResponse> _cache =
      LinkedHashMap<String, _CachedResponse>();

  /// Get cached response if available and not expired (30 min TTL)
  String? getCachedResponse(String prompt) {
    final key = _generateCacheKey(prompt);
    final cached = _cache[key];
    if (cached != null) {
      final age = DateTime.now().difference(cached.timestamp);
      if (age.inMinutes < 30) {
        log('📦 Cache HIT - Saving API call!');
        // Move to end (most recently used)
        _cache.remove(key);
        _cache[key] = cached;
        return cached.response;
      } else {
        // Expired
        _cache.remove(key);
        log('📦 Cache EXPIRED - Will make new API call');
      }
    }
    return null;
  }

  /// Store response in cache
  void cacheResponse(String prompt, String response) {
    final key = _generateCacheKey(prompt);
    // Evict oldest if full
    if (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = _CachedResponse(
      response: response,
      timestamp: DateTime.now(),
    );
    log('📦 Response cached (${_cache.length}/$_maxCacheSize entries)');
  }

  /// Clear all cached responses
  void clearCache() {
    _cache.clear();
    log('📦 Cache cleared');
  }

  String _generateCacheKey(String prompt) {
    // Simple hash based on first 200 chars + length for fast comparison
    final trimmed = prompt.trim().toLowerCase();
    return '${trimmed.length}_${trimmed.hashCode}';
  }

  // ─── Input Validation (Client-Side) ─────────────────────────────
  /// Returns null if valid, or error message string if invalid.
  /// Checks for gibberish, too short, empty, or special char spam.
  static String? validateInput(String input, {int minLength = 3}) {
    final trimmed = input.trim();

    if (trimmed.isEmpty) {
      return 'Please enter a topic or description';
    }

    if (trimmed.length < minLength) {
      return 'Input is too short. Please provide more details';
    }

    // Check for keyboard spam / gibberish patterns
    if (_isGibberish(trimmed)) {
      return 'Please enter a valid topic or description';
    }

    return null; // valid
  }

  static bool _isGibberish(String text) {
    // 1. Only special characters or numbers
    if (RegExp(
      r'^[^a-zA-Z\u0600-\u06FF\u0900-\u097F\u4e00-\u9fff\uac00-\ud7af\u0400-\u04FF]+$',
    ).hasMatch(text)) {
      return true;
    }

    // 2. Same character repeated excessively (e.g. "aaaaaa", "xyzxyzxyz")
    if (RegExp(r'(.)\1{5,}').hasMatch(text)) {
      return true;
    }

    // 3. Random consonant clusters without vowels (e.g. "bdfghjklmn")
    final words = text.split(RegExp(r'\s+'));
    int gibberishWords = 0;
    for (final word in words) {
      if (word.length > 3 &&
          RegExp(
            r'^[bcdfghjklmnpqrstvwxyz]{4,}$',
            caseSensitive: false,
          ).hasMatch(word)) {
        gibberishWords++;
      }
    }
    if (words.isNotEmpty && gibberishWords / words.length > 0.6) {
      return true;
    }

    return false;
  }

  // ─── Input Trimming ─────────────────────────────────────────────
  /// Trim and limit input text to save tokens
  static String trimInput(String input, {int maxLength = maxTopicLength}) {
    String trimmed = input.trim();
    // Remove excessive whitespace
    trimmed = trimmed.replaceAll(RegExp(r'\s+'), ' ');
    // Enforce character limit
    if (trimmed.length > maxLength) {
      trimmed = trimmed.substring(0, maxLength);
      // Don't cut in the middle of a word
      final lastSpace = trimmed.lastIndexOf(' ');
      if (lastSpace > maxLength * 0.8) {
        trimmed = trimmed.substring(0, lastSpace);
      }
    }
    return trimmed;
  }

  // ─── Generation Config ──────────────────────────────────────────
  /// Returns optimized generationConfig based on tool type
  static Map<String, dynamic> getGenerationConfig(String toolName) {
    switch (toolName) {
      case 'Story Generator':
        return {
          'temperature': 0.8,
          'maxOutputTokens': 2048,
          'topP': 0.9,
          'topK': 40,
        };
      case 'Essay Writer':
        return {
          'temperature': 0.6,
          'maxOutputTokens': 2048,
          'topP': 0.9,
          'topK': 40,
        };
      case 'Script Writer':
        return {
          'temperature': 0.7,
          'maxOutputTokens': 2048,
          'topP': 0.9,
          'topK': 40,
        };
      case 'Blog Writer':
        return {
          'temperature': 0.7,
          'maxOutputTokens': 2500,
          'topP': 0.9,
          'topK': 40,
        };
      case 'YouTube Script':
        return {
          'temperature': 0.7,
          'maxOutputTokens': 2500,
          'topP': 0.9,
          'topK': 40,
        };
      case 'Character Story':
        return {
          'temperature': 0.8,
          'maxOutputTokens': 1500,
          'topP': 0.9,
          'topK': 40,
        };
      case 'Rewrite Story':
        return {
          'temperature': 0.6,
          'maxOutputTokens': 2500,
          'topP': 0.85,
          'topK': 40,
        };
      case 'Title Generator':
        return {
          'temperature': 0.9,
          'maxOutputTokens': 800,
          'topP': 0.95,
          'topK': 40,
        };
      default:
        return {
          'temperature': 0.7,
          'maxOutputTokens': 2048,
          'topP': 0.9,
          'topK': 40,
        };
    }
  }

  /// System instruction that applies to all tools — saves prompt tokens
  /// by not repeating this in every prompt.
  static String get systemInstruction =>
      '''You are a professional creative writing AI assistant. Follow these rules for ALL responses:
1. If the user input is gibberish, random characters, or nonsensical, respond ONLY with: "INVALID_INPUT"
2. Never include any preamble, confirmation, or acknowledgment text like "Sure!" or "Here's your...". Go directly to the content.
3. Use clear formatting with markdown headings and paragraphs.
4. Write in simple, engaging language.
5. Be concise but high quality — no filler text or unnecessary repetition.''';
}

class _CachedResponse {
  final String response;
  final DateTime timestamp;

  _CachedResponse({required this.response, required this.timestamp});
}
