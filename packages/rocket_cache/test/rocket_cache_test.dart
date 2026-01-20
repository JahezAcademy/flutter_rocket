import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rocket_cache/rocket_cache.dart';
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await RocketCache.init();
  });

  group('RocketCache Tests', () {
    test('Save and Load data', () async {
      const key = 'test_key';
      const data = {'name': 'John', 'age': 30};

      await RocketCache.save(key, data);
      final loadedData = await RocketCache.load(key);

      expect(loadedData, equals(data));
    });

    test('Load non-existent data returns null', () async {
      final loadedData = await RocketCache.load('non_existent');
      expect(loadedData, isNull);
    });

    test('Data expiration', () async {
      const key = 'expire_key';
      const data = 'some_data';

      // Save data
      await RocketCache.save(key, data);

      // Load with long expiration
      final validData =
          await RocketCache.load(key, expiration: const Duration(hours: 1));
      expect(validData, equals(data));

      // Manually modify the timestamp in SharedPreferences to simulate expiration
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getString(key)!;
      final decoded = json.decode(encoded);

      // Set timestamp to 2 hours ago
      decoded['timestamp'] = DateTime.now()
          .subtract(const Duration(hours: 2))
          .millisecondsSinceEpoch;
      await prefs.setString(key, json.encode(decoded));

      // Load with 1 hour expiration - should be expired now
      final expiredData =
          await RocketCache.load(key, expiration: const Duration(hours: 1));
      expect(expiredData, isNull);

      // Check if it was deleted
      expect(prefs.getString(key), isNull);
    });

    test('Delete and Clear', () async {
      await RocketCache.save('key1', 'data1');
      await RocketCache.save('key2', 'data2');

      await RocketCache.delete('key1');
      expect(await RocketCache.load('key1'), isNull);
      expect(await RocketCache.load('key2'), isNotNull);

      await RocketCache.clear();
      expect(await RocketCache.load('key2'), isNull);
    });
  });
}
