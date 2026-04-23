import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A persistence and caching layer using SharedPreferences.
class RocketCache {
  static SharedPreferences? _prefs;

  /// Initializes the cache. Called automatically if not called explicitly.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Resets the cache instance. Useful for testing.
  @visibleForTesting
  static void resetForTesting() {
    _prefs = null;
  }

  /// Save data to cache.
  ///
  /// [key] The cache key.
  /// [data] The data to cache. Must be JSON-serializable.
  ///
  /// Returns `true` if saved successfully, `false` otherwise.
  static Future<bool> save(String key, dynamic data) async {
    try {
      if (_prefs == null) await init();
      final encodedData = json.encode({
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      return await _prefs!.setString(key, encodedData);
    } catch (e) {
      return false;
    }
  }

  /// Load data from cache.
  ///
  /// [key] The cache key.
  /// [expiration] Optional expiration duration. If expired, returns null and deletes the cache.
  ///
  /// Returns the cached data, or `null` if not found or expired.
  static Future<dynamic> load(String key, {Duration? expiration}) async {
    try {
      if (_prefs == null) await init();
      final encodedData = _prefs!.getString(key);
      if (encodedData == null) return null;

      final decoded = json.decode(encodedData) as Map<String, dynamic>;
      if (expiration != null) {
        final timestamp =
            DateTime.fromMillisecondsSinceEpoch(decoded['timestamp'] as int);
        if (DateTime.now().difference(timestamp) > expiration) {
          await delete(key);
          return null;
        }
      }
      return decoded['data'];
    } catch (e) {
      return null;
    }
  }

  /// Delete data from cache.
  ///
  /// [key] The cache key to delete.
  ///
  /// Returns `true` if deleted successfully, `false` otherwise.
  static Future<bool> delete(String key) async {
    try {
      if (_prefs == null) await init();
      return await _prefs!.remove(key);
    } catch (e) {
      return false;
    }
  }

  /// Clear all cache.
  ///
  /// Returns `true` if cleared successfully, `false` otherwise.
  static Future<bool> clear() async {
    try {
      if (_prefs == null) await init();
      return await _prefs!.clear();
    } catch (e) {
      return false;
    }
  }

  /// Check if a key exists in cache.
  static Future<bool> contains(String key) async {
    try {
      if (_prefs == null) await init();
      return _prefs!.containsKey(key);
    } catch (e) {
      return false;
    }
  }
}
