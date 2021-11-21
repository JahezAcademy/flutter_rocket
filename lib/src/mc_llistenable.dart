import 'dart:ui';

abstract class McListenable {
  Map<String, VoidCallback> _observers = {};

  void registerListener(String key, VoidCallback listener) {
    _observers[key] = listener;
  }

  void registerListeners(Map<String, VoidCallback> listeners) {
    _observers.addAll(listeners);
  }

  void notifyListener(String key) {
    _observers[key]!.call();
  }

  void notifyListeners(List<String> keys) {
    _observers.forEach((key, value) {
      if (keys.contains(key)) value.call();
    });
  }

  void removeListener(String key) {
    _observers.remove(key);
  }

  void removeListeners(List<String> keys) {
    _observers.removeWhere((key, value) => keys.contains(key));
  }

  bool get hasListeners {
    return _observers.isNotEmpty;
  }
}
