import 'package:mc/src/mc_model.dart';

/// حاص بتخزين النماذج المستحدمة و الحفاظ على البياتات
class McController {
  static final McController _controller = McController._internal();
  Map<String, dynamic> models = {};

  /// اضافة تموذج جديد
  T add<T>(String key, T model, {bool readOnly = false}) {
    if (readOnly) {
      if (!models.containsKey(key)) {
        models[key] = model;
        return model;
      } else {
        return models[key];
      }
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

  // حذف نموذج بشرط معين
  void removeWhere(bool Function(String, dynamic) test) {
    models.removeWhere(test);
  }

  factory McController([String? key, McModel? model]) {
    if (key != null && model != null) {
      _controller.add(key, model);
    }
    return _controller;
  }

  McController._internal();
}
