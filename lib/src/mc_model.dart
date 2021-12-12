import 'dart:ui';

import 'mc_llistenable.dart';

/// يجب ان ترث النماذج المستخدمة من هذا الكائن
abstract class McModel<T> extends McListenable {
  bool loading = false;
  bool loadingChecker = false;
  List<T>? multi;
  bool failed = false;
  bool existData = false;
  String exception = "";
  String? response;
  static final String rebuild = "rebuild";

  /// تفعيل و الغاء جاري التحميل
  void load(bool t) {
    loading = loadingChecker ? false : t;
    callListener(rebuild);
  }

  /// التقاط الخطأ
  void setException(
      String _exception, StackTrace stackTrace, String? _response) {
    exception = _exception;
    response = _response;
    callListener(rebuild);
  }

  void loadingChecking(bool value) {
    loadingChecker = value;
    callListener(rebuild);
  }

  bool hasListener() {
    return super.hasListeners;
  }

  ///في حالة وجود خطأ
  void setFailed(bool state) {
    failed = state;
    callListener(rebuild);
  }

  ///حذف النموذج من قائمة النماذج
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

  ///json من النماذج الى بيانات
  Map<String, dynamic> toJson() {
    return {};
  }

  ///التحكم في اعادة البناء عن طريق تفعيل جاري التحميل و الغاءه
  void rebuildWidget() {
    callListener(rebuild);
  }

  @override
  /// for add listener to rebuild widget you can use rebuild as key
  void registerListener(String key, VoidCallback listener) {
    super.registerListener(key, listener);
  }
}
