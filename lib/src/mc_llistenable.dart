import 'dart:ui';

abstract class McListenable {
  Map<String, List<VoidCallback>> _observers = {};
  List<McListenable> merges = [];
  bool get isMerged {
    return merges.isNotEmpty;
  }

  void registerListener(String key, VoidCallback listener) {
    if (_observers[key] == null) _observers[key] = [];
    _observers[key]!.add(listener);
  }

  void registerListeners(Map<String, List<VoidCallback>> listeners) {
    _observers.addAll(listeners);
  }

  void callListener(String key) {
    if (_observers.containsKey(key)) _observers[key]!.forEach((l) => l.call());
  }

  void callListeners(List<String> keys) {
    _observers.forEach((key, value) {
      if (keys.contains(key)) value.forEach((l) => l.call());
    });
  }

  void removeListener(String key, [VoidCallback? listener]) {
    if (_observers.containsKey(key))
      listener == null
          ? _observers.remove(key)
          : _observers[key]!.removeWhere((l) => l == listener);
  }

  void removeListeners(List<String> keys, [List<VoidCallback>? listeners]) {
    listeners == null
        ? _observers.removeWhere((key, value) => keys.contains(key))
        : _observers.forEach((key, value) {
            value.removeWhere((l) => listeners.contains(l));
          });
  }

  bool get hasListeners {
    return _observers.isNotEmpty;
  }

  bool keyHasListeners(String key) {
    if (_observers[key] == null) _observers[key] = [];
    return _observers[key]!.isNotEmpty;
  }

  List<String> get getListenersKeys {
    return _observers.keys.toList();
  }
}
