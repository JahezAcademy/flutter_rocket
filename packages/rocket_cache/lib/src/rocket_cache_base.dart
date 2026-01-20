import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RocketCache {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save data to cache
  static Future<void> save(String key, dynamic data) async {
    if (_prefs == null) await init();
    String encodedData = json.encode({
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    await _prefs!.setString(key, encodedData);
  }

  /// Load data from cache
  static Future<dynamic> load(String key, {Duration? expiration}) async {
    if (_prefs == null) await init();
    String? encodedData = _prefs!.getString(key);
    if (encodedData == null) return null;

    Map<String, dynamic> decoded = json.decode(encodedData);
    if (expiration != null) {
      DateTime timestamp =
          DateTime.fromMillisecondsSinceEpoch(decoded['timestamp']);
      if (DateTime.now().difference(timestamp) > expiration) {
        await delete(key);
        return null;
      }
    }
    return decoded['data'];
  }

  /// Delete data from cache
  static Future<void> delete(String key) async {
    if (_prefs == null) await init();
    await _prefs!.remove(key);
  }

  /// Clear all cache
  static Future<void> clear() async {
    if (_prefs == null) await init();
    await _prefs!.clear();
  }
}
