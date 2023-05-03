import 'dart:collection';

import 'package:mvc_rocket/src/mc_extensions.dart';

/// Save your data with specific key
/// حاص بتخزين النماذج المستحدمة و الحفاظ على البياتات
class Rocket {
  Rocket._();

  static HashMap<String, dynamic>? _modelsDelegate;

  static HashMap<String, dynamic> get _models {
    return _modelsDelegate ??= HashMap<String, dynamic>();
  }

  /// اضافة تموذج جديد
  static T add<T>(String key, T model, {bool readOnly = false}) {
    if (readOnly) {
      return _models.putIfAbsent(key, () => model);
    } else {
      _models[key] = model;
      return model;
    }
  }

  /// الوصول لنموذج
  static T get<T>(String key) {
    return _models[key];
  }

  static Iterable<T> getByType<T>() {
    return _models.values.whereType<T>();
  }
  
  static T getFirstByType<T>() {
    return getByType<T>().first;
  }

  /// حذف النموذح
  static void remove(String key) {
    _models.remove(key);
  }

  /// التأكد من وجود المفتاح
  static bool hasKey(String key) {
    return _models.hasKey(key);
  }

  /// كل المفاتح المسجلة
  static List<String> get keys => _models.keys.toList();

  // حذف نموذج بشرط معين
  static void removeWhere(bool Function(String, dynamic) test) {
    _models.removeWhere(test);
  }
}
