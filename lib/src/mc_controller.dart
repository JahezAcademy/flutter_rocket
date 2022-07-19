import 'dart:collection';
import 'mc_extensions.dart';

/// حاص بتخزين النماذج المستحدمة و الحفاظ على البياتات
class RocketController {
  static final RocketController _controller = RocketController._internal();
  final HashMap<String, dynamic> _models = HashMap();

  /// اضافة تموذج جديد
  T add<T>(String key, T model, {bool readOnly = false}) {
    if (readOnly) {
      return _models.putIfAbsent(key, () => model);
    } else {
      _models[key] = model;
      return model;
    }
  }

  /// الوصول لنموذج
  T get<T>(String key) {
    return _models[key];
  }

  /// حذف النموذح
  void remove(String key) {
    _models.remove(key);
  }

  bool hasKey(String key) {
    return _models.hasKey(key);
  }

  List<String> get keys => _models.keys.toList();

  // حذف نموذج بشرط معين
  void removeWhere(bool Function(String, dynamic) test) {
    _models.removeWhere(test);
  }

  factory RocketController() {
    return _controller;
  }

  RocketController._internal();
}
