import 'dart:developer';
import 'package:flutter/foundation.dart';

import 'mc_constants.dart';
import 'mc_exception.dart';
import 'mc_llistenable.dart';

/// يجب ان ترث النماذج المستخدمة من هذا الكائن
abstract class RocketModel<T> extends RocketListenable {
  dynamic instance;
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
  void setException(RocketException response) {
    exception = response;
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

  T _mapToInstance(e) {
    var copy = instance;
    copy.fromJson(e, isSub: true);
    return copy;
  }

  /// ملئ النماذج من البيانات القادمة م ن الخادم
  void setMulti(List data) {
    multi = data.map<T>(_mapToInstance).toList();
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
  Map<String, dynamic> toJson();

  DateTime _time = DateTime.now();

  /// التحكم في اعادة البناء يدويا
  void rebuildWidget() {
    if (enableDebug) {
      if (state == RocketState.loading) {
        _time = DateTime.now();
        log('${T.toString()} : ${state.name}');
      }

      if (state == RocketState.done || state == RocketState.failed) {
        int dur = DateTime.now().difference(_time).inMilliseconds;
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
