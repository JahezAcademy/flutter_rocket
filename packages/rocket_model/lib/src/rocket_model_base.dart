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
  /// This must be overridden in subclasses to return a new instance of the model (e.g. `get instance => MyModel()`).
  T get instance =>
      throw UnimplementedError("instance getter must be implemented for $T");

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

  dynamic apiResponse;
  int? statusCode;

  /// Sets the current state of the model.
  set state(RocketState currentState) {
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
  void setException(RocketException rocketException) {
    exception = rocketException;
    state = RocketState.failed;
    if (enableDebug) {
      log("Failed details :${exception.toString()}", name: "flutter_rocket");
    }
  }

  /// Sets the loading checker flag.
  set loadingChecking(bool value) {
    _loadingChecker = value;
  }

  /// Deletes the data object at the specified index.
  void delItem(int index) {
    T item = all!.removeAt(index);
    if (item is RocketModel) {
      item.removeListener(rocketRebuild, _handleChildChange);
    }
    rebuildWidget(fromUpdate: true);
  }

  /// Adds a new data object.
  void addItem(T newModel) {
    all ??= [];
    all!.add(newModel);
    if (newModel is RocketModel) {
      newModel.registerListener(rocketRebuild, _handleChildChange);
    }
    rebuildWidget(fromUpdate: true);
  }

  /// Maps the given data to an instance of the model.
  T _mapToInstance(e) {
    var copy = instance;
    if (copy is RocketModel) {
      copy.fromJson(e, isSub: true);
      copy.registerListener(rocketRebuild, _handleChildChange);
    }
    return copy;
  }

  /// Sets the model's data to the given list of data.
  void setMulti(List data) {
    if (all != null) {
      for (var item in all!) {
        if (item is RocketModel) {
          item.removeListener(rocketRebuild, _handleChildChange);
        }
      }
    }
    all = data.map<T>(_mapToInstance).toList();
    existData = true;
    state = RocketState.done;
  }

  void _handleChildChange() {
    rebuildWidget(fromUpdate: true);
  }

  /// Deserializes the model's data from the given JSON map.
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
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
  ///
  /// Use `fields` to notify only listeners registered for specific keys, enabling selective rebuilding.
  void rebuildWidget({bool fromUpdate = false, List<String>? fields}) {
    if (enableDebug) {
      if (fromUpdate) {
        log('${T.toString()} : Updated ${fields != null ? "fields: $fields" : ""}',
            name: "flutter_rocket");
      } else {
        log('${T.toString()} : State changed to $state',
            name: "flutter_rocket");
      }
    }

    if (fields != null) {
      callListeners(fields);
    } else {
      callListener(rocketRebuild);
    }
  }
}
