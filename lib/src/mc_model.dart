import 'mc_llistenable.dart';

/// يجب ان ترث النماذج المستخدمة من هذا الكائن
abstract class McModel<T> extends McListenable {
  McModel() {
    this.registerListener(_rebuild, () {});
  }
  bool loading = false;
  bool loadingChecker = false;
  List<T> multi = [];
  bool failed = false;
  bool existData = false;
  String exception = "";
  String? response;
  final String _rebuild = "rebuild";

  /// تفعيل و الغاء جاري التحميل
  void load(bool t) {
    loading = loadingChecker ? false : t;
    notifyListener(_rebuild);
  }

  /// التقاط الخطأ
  void setException(
      String _exception, StackTrace stackTrace, String? _response) {
    exception = _exception;
    response = _response;
    notifyListener(_rebuild);
  }

  void loadingChecking(bool value) {
    loadingChecker = value;
    notifyListener(_rebuild);
  }

  bool hasListener() {
    return super.hasListeners;
  }

  ///في حالة وجود خطأ
  void setFailed(bool state) {
    failed = state;
    notifyListener(_rebuild);
  }

  ///حذف النموذج من قائمة النماذج
  void delItem(int index) {
    multi.removeAt(index);
    notifyListener(_rebuild);
  }

  /// ملئ النماذج من البيانات القادمة من الخادم
  void setMulti(List data) {
    notifyListener(_rebuild);
  }

  /// من البيانات القادمة من الخادم الى نماذج
  void fromJson(Map<String, dynamic>? json) {
    notifyListener(_rebuild);
  }

  ///json من النماذج الى بيانات
  Map<String, dynamic> toJson() {
    return {};
  }

  ///التحكم في اعادة البناء عن طريق تفعيل جاري التحميل و الغاءه
  void rebuild() {
    notifyListener(_rebuild);
  }
}
