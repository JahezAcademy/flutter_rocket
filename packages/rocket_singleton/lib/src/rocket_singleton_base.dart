import 'dart:collection';

class Rocket {
  Rocket._();

  static HashMap<String, dynamic> get _models =>
      _modelsDelegate ??= HashMap<String, dynamic>();

  static HashMap<String, dynamic>? _modelsDelegate;

  /// Adds a value to the collection.
  ///
  /// [value] The value to add.
  /// [key] The key to use for the value. If not provided, the value's runtime type will be used.
  /// [readOnly] Whether the value is read-only. If true, the value cannot be replaced from the collection.
  ///
  /// Returns the added value.
  static T add<T>(T value, {String? key, bool readOnly = false}) {
    key ??= value.runtimeType.toString();
    if (readOnly) {
      return _models.putIfAbsent(key, () => value);
    } else {
      _models[key] = value;
      return value;
    }
  }

  /// Gets a value from the collection.
  ///
  /// [key] The key of the value to get.
  ///
  /// Returns the value.
  static T get<T>([String? key]) {
    if (key == null) return getFirstByType<T>();
    return _models[key] as T;
  }

  /// Iterates over all rocket models in the collection.
  ///
  /// [action] The function to call for each value.
  static void forEach(void Function(String, dynamic) action) {
    _models.forEach(action);
  }

  /// Removes a value from the collection.
  ///
  /// [key] The key of the value to remove.
  ///
  /// Throws an AssertionError if no value with the given key exists.
  static void remove<T>({String? key}) {
    if (key == null) {
      _models.removeWhere((key, value) => value is T);
      return;
    }
    _models.remove(key);
  }

  /// Returns true if the collection contains a value with the given key.
  static bool hasKey(String key) {
    return _models.containsKey(key);
  }

  /// Returns true if the collection contains a value of the given type.
  static bool hasType<T>() {
    return _models.values.any((value) => value is T);
  }

  /// Gets a list of the keys of all rocket models in the collection.
  static List<String> get keys => _models.keys.toList();

  /// Removes all rocket models from the collection that match the given predicate.
  ///
  /// [test] The predicate to test each value against.
  static void removeWhere(bool Function(String, dynamic) test) {
    _models.removeWhere(test);
  }

  /// Gets a list of all rocket models in the collection of the given type.
  ///
  /// [T] The type of rocket models to get.
  ///
  /// Returns a list of rocket models of the given type.
  static List<T> getByType<T>() {
    // assert(hasType<T>(), "No value of type $T");
    return _models.values.whereType<T>().toList();
  }

  /// Gets the first value in the collection of the given type.
  ///
  /// [T] The type of rocket models to get.
  ///
  /// Returns the first value of the given type, or null if no models of the given type exist.
  static T getFirstByType<T>() {
    final result = getByType<T>().firstOrNull;
    if (result == null) {
      throw Exception("No value of type $T found.");
    }
    return result;
  }

  /// Removes all rocket models from the collection.
  static void clear() {
    _models.clear();
  }
}
