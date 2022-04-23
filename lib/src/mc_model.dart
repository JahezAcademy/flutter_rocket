import 'dart:ui';
import 'mc_constants.dart';
import 'mc_exception.dart';
import 'mc_llistenable.dart';

/// يجب ان ترث النماذج المستخدمة من هذا الكائن
abstract class RocketModel<T> extends RocketListenable {
  bool loading = false;
  bool _loadingChecker = false;
  List<T>? multi;
  bool failed = false;
  bool existData = false;
  bool get enableDebug => kDebugMode;
  RocketException exception = RocketException();

  /// تفعيل و الغاء جاري التحميل
  void load(bool t) {
    loading = _loadingChecker ? false : t;
    callListener(rebuild);
  }

  /// التقاط الخطأ
  void setException(RocketException _response) {
    exception = _response;
    callListener(rebuild);
  }

  void loadingChecking(bool value) {
    _loadingChecker = value;
    callListener(rebuild);
  }

  bool hasListener() {
    return super.hasListeners;
  }

  ///في حالة وجود خط أ
  void setFailed(bool state) {
    failed = state;
    callListener(rebuild);
  }

  /// حذف النموذج من قائمة النماذج
  void delItem(int index) {
    multi!.removeAt(index);
    callListener(rebuild);
  }

  /// ملئ النماذج من البيانات القادمة من الخادم
  void setMulti(List data) {
    callListener(rebuild);
  }

  /// من البيانات القادمة من الخادم الى نماذج
  void fromJson(Map<String, dynamic>? json) {
    callListener(rebuild);
  }

  /// json من النماذج الى بيانات
  Map<String, dynamic> toJson() {
    return {};
  }

  /// التحكم في اعادة البناء يدويا
  void rebuildWidget() {
    callListener(rebuild);
  }

  @override

  /// لاضافة اوامر سيتم تنفيذها اذا تم عمل اعادة البناء للجزء المرتبط مع هذا النموذج
  void registerListener(String key, VoidCallback listener) {
    super.registerListener(key, listener);
  }
}
