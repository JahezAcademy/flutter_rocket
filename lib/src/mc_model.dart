import 'package:flutter/material.dart';

/// يجب ان ترث النماذج المستخدمة من هذا الكائن
abstract class McModel<T> extends ChangeNotifier {
  bool loading = false;
  bool loadingChecker = false;
  List<T> multi = [];
  bool failed = false;
  bool existData = false;
  String exception = "";
  Map<int, String> statusCode = {};

  /// تفعيل و الغاء جاري التحميل
  void load(bool t) {
    loading = loadingChecker ? false : t;
    notifyListeners();
  }

  /// التقاط الخطأ
  void setException(String _exception, Map<int, String> status) {
    exception = _exception;
    statusCode = status;
    notifyListeners();
  }

  void loadingChecking(bool value) {
    loadingChecker = value;
    notifyListeners();
  }

  bool hasListener() {
    return super.hasListeners;
  }

  ///في حالة وجود خطأ
  void setFailed(bool state) {
    failed = state;
    notifyListeners();
  }

  ///حذف النموذج من قائمة النماذج
  void delItem(int index) {
    multi.removeAt(index);
    notifyListeners();
  }

  /// ملئ النماذج من البيانات القادمة من الخادم
  void setMulti(List data) {
    notifyListeners();
  }

  /// من البيانات القادمة من الخادم الى نماذج
  void fromJson(Map<String, dynamic>? json) {
    notifyListeners();
  }

  ///json من النماذج الى بيانات
  Map<String, dynamic> toJson() {
    return {};
  }

  ///التحكم في اعادة البناء عن طريق تفعيل جاري التحميل و الغاءه
  void rebuild() {
    load(true);
    load(false);
  }
}
