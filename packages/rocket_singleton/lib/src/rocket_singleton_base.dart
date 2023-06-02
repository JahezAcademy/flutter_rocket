import 'dart:collection';
import 'extensions.dart';

class Rocket {
  Rocket._();

  static HashMap<String, dynamic> get _models =>
      _modelsDelegate ??= HashMap<String, dynamic>();

  static HashMap<String, dynamic>? _modelsDelegate;

  /// Adds a rocket model to the collection.
  ///
  /// [model] The rocket model to add.
  /// [key] The key to use for the model. If not provided, the model's runtime type will be used.
  /// [readOnly] Whether the model is read-only. If true, the model cannot be replaced from the collection.
  ///
  /// Returns the added model.
  static T add<T>(T model, {String? key, bool readOnly = false}) {
    key ??= model.runtimeType.toString();
    if (readOnly) {
      return _models.putIfAbsent(key, () => model);
    } else {
      _models[key] = model;
      return model;
    }
  }

  /// Gets a rocket model from the collection.
  ///
  /// [key] The key of the model to get.
  ///
  /// Returns the model, or null if no model with the given key exists.
  static T get<T>([String? key]) {
    assert(key != null || getByType<T>().isNotEmpty,
        "No model of type $T and key $key");
    if (key == null) return getFirstByType<T>();
    return _models[key];
  }

  /// Iterates over all rocket models in the collection.
  ///
  /// [action] The function to call for each model.
  static void forEach(void Function(String, dynamic) action) {
    _models.forEach(action);
  }

  /// Removes a rocket model from the collection.
  ///
  /// [key] The key of the model to remove.
  ///
  /// Throws an AssertionError if no model with the given key exists.
  static void remove<T>({String? key}) {
    assert(key != null || getByType<T>().isNotEmpty,
        "No model of type $T and key $key");
    key ??= T.toString();
    _models.remove(key);
  }

  /// Returns true if the collection contains a model with the given key.
  static bool hasKey(String key) {
    return _models.hasKey(key);
  }

  /// Returns true if the collection contains a model of the given type.
  static bool hasType<T>() {
    final String key = T.toString();
    return _models.hasKey(key);
  }

  /// Gets a list of the keys of all rocket models in the collection.
  static List<String> get keys => _models.keys.toList();

  /// Removes all rocket models from the collection that match the given predicate.
  ///
  /// [test] The predicate to test each model against.
  static void removeWhere(bool Function(String, dynamic) test) {
    _models.removeWhere(test);
  }

  /// Gets a list of all rocket models in the collection of the given type.
  ///
  /// [T] The type of rocket models to get.
  ///
  /// Returns a list of rocket models of the given type.
  static List<T> getByType<T>() {
    assert(hasType<T>(), "No model of type $T");
    return _models.values.whereType<T>().toList();
  }

  /// Gets the first rocket model in the collection of the given type.
  ///
  /// [T] The type of rocket models to get.
  ///
  /// Returns the first rocket model of the given type, or null if no models of the given type exist.
  static T getFirstByType<T>() {
    assert(getByType<T>().isNotEmpty, "No model of type $T");
    return getByType<T>().first;
  }

  /// Removes all rocket models from the collection.
  static void removeAll() {
    _models.clear();
  }
}
