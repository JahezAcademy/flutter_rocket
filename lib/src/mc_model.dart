import 'dart:developer';
import 'package:flutter/foundation.dart';

import 'mc_constants.dart';
import 'mc_exception.dart';
import 'mc_llistenable.dart';

/// يجب ان ترث النماذج المستخدمة من هذا الكائن
abstract class RocketModel<T> extends RocketListenable {
  bool _loadingChecker = false;
  bool existData = false;
  bool get enableDebug => kDebugMode;
  RocketException exception = RocketException();
  List<T>? multi;
  RocketState _state = RocketState.done;
  RocketState get state => _state;
  set state(currentState) {
    _state = currentState == RocketState.loading
        ? _loadingChecker
            ? state
            : currentState
        : currentState;
    if (_state == RocketState.failed) {
      existData = false;
    }
    rebuildWidget();
  }

  /// التقاط الخطأ
  void setException(RocketException _response) {
    exception = _response;
    state = RocketState.failed;
  }

  set loadingChecking(bool value) {
    _loadingChecker = value;
  }

  /// حذف النموذج من قائمة النماذج
  void delItem(int index) {
    multi!.removeAt(index);
    rebuildWidget();
  }

  /// ملئ النماذج من البيانات القادمة من الخادم
  void setMulti(List data) {
    existData = true;
    state = RocketState.done;
  }

  /// من البيانات القادمة من الخادم الى نماذج
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if (!isSub) {
      existData = true;
      state = RocketState.done;
    }
  }

  /// json من النماذج الى بيانات
  Map<String, dynamic> toJson() {
    return {};
  }

  late DateTime time;

  /// التحكم في اعادة البناء يدويا
  void rebuildWidget() {
    if (enableDebug) {
      if (state == RocketState.loading) {
        time = DateTime.now();
        log('${T.toString()} : ${state.name}');
      }

      if (state == RocketState.done || state == RocketState.failed) {
        int dur = DateTime.now().difference(time).inMilliseconds;
        log('${T.toString()} : ${state.name} in $dur ms');
      }
    }

    callListener(rocketRebuild);
  }

  /// لاضافة اوامر سيتم تنفيذها اذا تم عمل اعادة البناء للجزء المرتبط مع هذا النموذج
  @override
  void registerListener(String key, VoidCallback listener) {
    super.registerListener(key, listener);
  }
}
