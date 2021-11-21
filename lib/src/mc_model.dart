
import 'mc_llistenable.dart';

/// يجب ان ترث النماذج المستخدمة من هذا الكائن
abstract class McModel<T> extends McListenable{
  McModel(){
    this.registerListener(_initial, (){});
  }
  bool loading = false;
  bool loadingChecker = false;
  List<T> multi = [];
  bool failed = false;
  bool existData = false;
  String exception = "";
  Map<int, String> statusCode = {};
  final String  _initial = "initial";
  /// تفعيل و الغاء جاري التحميل
  void load(bool t) {
    loading = loadingChecker ? false : t;
    notifyListener("initial");
  }

  /// التقاط الخطأ
  void setException(String _exception, Map<int, String> status) {
    exception = _exception;
    statusCode = status;
    notifyListener(_initial);
  }

  void loadingChecking(bool value) {
    loadingChecker = value;
    notifyListener(_initial);
  }

  bool hasListener() {
    return super.hasListeners;
  }

  ///في حالة وجود خطأ
  void setFailed(bool state) {
    failed = state;
    notifyListener(_initial);
  }

  ///حذف النموذج من قائمة النماذج
  void delItem(int index) {
    multi.removeAt(index);
    notifyListener(_initial);
  }

  /// ملئ النماذج من البيانات القادمة من الخادم
  void setMulti(List data) {
    notifyListener(_initial);
  }

  /// من البيانات القادمة من الخادم الى نماذج
  void fromJson(Map<String, dynamic>? json) {
    notifyListener(_initial);
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
