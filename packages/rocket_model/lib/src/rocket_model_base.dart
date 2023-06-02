import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:rocket_listenable/rocket_listenable.dart';

import 'constants.dart';

import 'rocket_exception.dart';

/// An abstract class that defines the behavior of a model object.
///
/// A model object is a class that represents data and provides methods for managing and updating that data.
/// The data can be stored in various forms (e.g. in-memory, in a database, or on a server) and can be accessed
/// and manipulated through the model object's public methods.
abstract class RocketModel<T> extends RocketListenable {
  /// The dynamic instance of the model.
  dynamic instance;

  /// A flag indicating whether the model is currently loading data.
  bool _loadingChecker = false;

  /// A flag indicating whether the model contains any data.
  bool existData = false;

  /// A flag indicating whether debug mode is enabled.
  bool get enableDebug => kDebugMode;

  /// An exception object that represents any errors that occur during data loading or manipulation.
  RocketException exception = RocketException();

  /// A list of all data objects of type T.
  List<T>? all;

  /// The current state of the model.
  RocketState _state = RocketState.done;

  /// Returns the current state of the model.
  RocketState get state => _state;

  /// Sets the current state of the model.
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

  /// Sets the exception object with the given exception.
  void setException(RocketException exception) {
    exception = exception;
    state = RocketState.failed;
    if (enableDebug) {
      log("[MVCR]> Failed details :${exception.toString()}");
    }
  }

  /// Sets the loading checker flag.
  set loadingChecking(bool value) {
    _loadingChecker = value;
  }

  /// Deletes the data object at the specified index.
  void delItem(int index) {
    all!.removeAt(index);
    rebuildWidget(fromUpdate: true);
  }

  /// Adds a new data object.
  void addItem(T newModel) {
    all!.add(newModel);
    rebuildWidget(fromUpdate: true);
  }

  /// Maps the given data to an instance of the model.
  T _mapToInstance(e) {
    var copy = instance;
    copy.fromJson(e, isSub: true);
    return copy;
  }

  /// Sets the model's data to the given list of data.
  void setMulti(List data) {
    all = data.map<T>(_mapToInstance).toList();
    existData = true;
    state = RocketState.done;
  }

  /// Deserializes the model's data from the given JSON map.
  void fromJson(Map<String, dynamic> json, {bool isSub = false}) {
    if (!isSub) {
      existData = true;
      state = RocketState.done;
    }
  }

  /// Serializes the model's data to a JSON map.
  Map<String, dynamic> toJson() => {};

  /// Notifies listeners that the model has changed and needs to be rebuilt.
  ///
  /// If the `fromUpdate` flag is true, this method indicates that the model has been updated rather than
  /// loaded from scratch. If `enableDebug` is true, this method logs a message indicating the current state
  /// of the model. Finally, this method calls the `callListener` method inherited from `RocketListenable`
  /// to notify any registered listeners that the model has changed.
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
}
