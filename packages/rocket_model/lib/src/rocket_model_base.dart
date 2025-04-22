import 'dart:developer';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:rocket_listenable/rocket_listenable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'constants.dart';
import 'rocket_exception.dart';

abstract class RocketModel<T> extends RocketListenable {
  dynamic instance;
  bool _loadingChecker = false;
  bool existData = false;
  bool get enableDebug => kDebugMode;
  RocketException exception = RocketException();
  List<T>? all;
  RocketState _state = RocketState.done;
  RocketState get state => _state;
  dynamic apiResponse;
  int? statusCode;

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

  void setException(RocketException rocketException) {
    exception = rocketException;
    state = RocketState.failed;
    if (enableDebug) {
      log("[MVCR]> Failed details :${exception.toString()}");
    }
  }

  set loadingChecking(bool value) {
    _loadingChecker = value;
  }

  void delItem(int index) {
    all!.removeAt(index);
    rebuildWidget(fromUpdate: true);
  }

  void addItem(T newModel) {
    all!.add(newModel);
    rebuildWidget(fromUpdate: true);
  }

  T _mapToInstance(e) {
    var copy = instance;
    copy.fromJson(e, isSub: true);
    return copy;
  }

  void setMulti(List data) {
    all = data.map<T>(_mapToInstance).toList();
    existData = true;
    state = RocketState.done;
  }

  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if (!isSub) {
      existData = true;
      state = RocketState.done;
    }
  }

  Map<String, dynamic> toJson() => {};

  void rebuildWidget({bool fromUpdate = false}) {
    if (fromUpdate && enableDebug) {
      log('[MVCR]> ${T.toString()} : Updated');
    } else {
      if (enableDebug) {
        if (state == RocketState.loading) {}

        if (state == RocketState.done || state == RocketState.failed) {}
      }
    }

    callListener(rocketRebuild);
  }

  Future<void> saveToLocalStorage(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> loadFromLocalStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> saveToCache(String key) async {
    final jsonString = jsonEncode(toJson());
    await saveToLocalStorage(key, jsonString);
  }

  Future<void> loadFromCache(String key) async {
    final jsonString = await loadFromLocalStorage(key);
    if (jsonString != null) {
      fromJson(jsonDecode(jsonString));
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> loadData() async {
    if (await isConnected()) {
      // Load data from API
    } else {
      await loadFromCache('example_model_cache');
    }
  }
}
