import 'mc_request.dart';

/// حاص بتخزين النماذج المستحدمة و الحفاظ على البياتات
class McController {
  static final McController _controller = McController._internal();
  Map<String, dynamic> models = {};

  /// اضافة تموذج جديد
  /// TODO: replace ! readonly parameter
  T add<T>(String key, T model) {
    if (key.contains('!')) {
      if (!models.containsKey(key.substring(1))) {
        models[key.substring(1)] = model;
        return model;
      } else {
        return models[key.substring(1)];
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

  // حذف لنموذج بشرط معين
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
