import 'dart:collection';

import 'mc_extensions.dart';

/// حاص بتخزين النماذج المستحدمة و الحفاظ على البياتات
class RocketController {
  final HashMap<String, dynamic> models = HashMap();
  static RocketController get instance {
    return RocketController();
  }

  /// اضافة تموذج جديد
  T add<T>(String key, T model, {bool readOnly = false}) {
    if (readOnly) {
      return models.putIfAbsent(key, () => model);
    } else {
      models[key] = model;
      return model;
    }
  }

  /// الوصول لنموذج
  T get<T>(String key) {
    return models[key];
  }

  /// حذف النموذح
  void remove(String key) {
    models.remove(key);
  }

  bool hasKey(String key) {
    return models.hasKey(key);
  }

  List<String> get keys => models.keys.toList();

  // حذف نموذج بشرط معين
  void removeWhere(bool Function(String, dynamic) test) {
    models.removeWhere(test);
  }
}
