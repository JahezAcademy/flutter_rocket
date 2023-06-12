import 'dart:collection';
import 'dart:ui';
import 'mc_extensions.dart';

abstract class RocketListenable {
  final HashMap<String, LinkedList<CustomLinkedListEntry<VoidCallback>>>
      _observers = HashMap();
  List<RocketListenable> merges = [];
  bool get isMerged {
    return merges.isNotEmpty;
  }

  void registerListener(String key, VoidCallback listener) {
    if (_observers[key] == null) {
      _observers[key] = LinkedList<CustomLinkedListEntry<VoidCallback>>();
    }
    _observers[key]!.add(CustomLinkedListEntry(listener));
  }

  void registerListeners(Map<String, List<VoidCallback>> listeners) {
    listeners.forEach((key, value) {
      for (var element in value) {
        _observers[key]!.add(CustomLinkedListEntry(element));
      }
    });
  }

  void callListener(String key) {
    if (_observers.containsKey(key)) {
      for (var l in _observers[key]!) {
        l.callBack.call();
      }
    }
  }

  void callListeners(List<String> keys) {
    _observers.forEach((key, value) {
      if (keys.contains(key)) {
        for (var l in value) {
          l.callBack.call();
        }
      }
    });
  }

  void removeListener(String key, [VoidCallback? listener]) {
    if (_observers.containsKey(key)) {
      listener == null
          ? _observers.remove(key)
          : _observers[key]!.removeWhere((l) => l.callBack == listener);
    }
  }

  void removeListeners(List<String> keys, [List<VoidCallback>? listeners]) {
    listeners == null
        ? _observers.removeWhere((key, value) => keys.contains(key))
        : _observers.forEach((key, value) {
            // ignore: iterable_contains_unrelated_type
            value.removeWhere((l) => listeners.contains(l));
          });
  }

  bool get hasListeners {
    return _observers.isNotEmpty;
  }

  bool keyHasListeners(String key) {
    if (_observers[key] == null) {
      _observers[key] = LinkedList<CustomLinkedListEntry<VoidCallback>>();
    }
    return _observers[key]!.isNotEmpty;
  }

  List<String> get getListenersKeys {
    return _observers.keys.toList();
  }

  void dispose() {
    _observers.clear();
  }
}

final class CustomLinkedListEntry<T>
    extends LinkedListEntry<CustomLinkedListEntry<VoidCallback>> {
  VoidCallback callBack;
  CustomLinkedListEntry(this.callBack);
  @override
  String toString() => '${super.toString()}: $callBack';
}
