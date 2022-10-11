import 'mc_controller.dart';


/// Save your data with specific key
 /// حاص بتخزين النماذج المستحدمة و الحفاظ على البياتات
class Rocket {
  Rocket._();

  static RocketController? _ghReporterDelegate;

  static RocketController get _instance {
    return _ghReporterDelegate ??= RocketController.instance;
  }

  /// اضافة تموذج جديد
  static T add<T>(String key, T model, {bool readOnly = false}) {
    return _instance.add(key, model, readOnly: readOnly);
  }

  /// الوصول لنموذج
  static T get<T>(String key) {
    return _instance.models[key];
  }

  /// حذف النموذح
  static void remove(String key) {
    _instance.remove(key);
  }

  static bool hasKey(String key) {
    return _instance.hasKey(key);
  }

  static List<String> get keys => _instance.keys.toList();

  // حذف نموذج بشرط معين
  static void removeWhere(bool Function(String, dynamic) test) {
    _instance.removeWhere(test);
  }
}