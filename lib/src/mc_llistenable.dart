import 'dart:collection';
import 'dart:ui';
import 'mc_extensions.dart';

abstract class McListenable {
  HashMap<String, LinkedList<MyLinkedListEntry<VoidCallback>>> _observers =
      HashMap();
  List<McListenable> merges = [];
  bool get isMerged {
    return merges.isNotEmpty;
  }

  void registerListener(String key, VoidCallback listener) {
    if (_observers[key] == null)
      _observers[key] = LinkedList<MyLinkedListEntry<VoidCallback>>();
    _observers[key]!.add(MyLinkedListEntry(listener));
  }

  void registerListeners(Map<String, List<VoidCallback>> listeners) {
    listeners.forEach((key, value) {
      value.forEach((element) {
        _observers[key]!.add(MyLinkedListEntry(element));
      });
    });
  }

  void callListener(String key) {
    if (_observers.containsKey(key))
      _observers[key]!.forEach((l) => l.callBack.call());
  }

  void callListeners(List<String> keys) {
    _observers.forEach((key, value) {
      if (keys.contains(key)) value.forEach((l) => l.callBack.call());
    });
  }

  void removeListener(String key, [VoidCallback? listener]) {
    if (_observers.containsKey(key))
      listener == null
          ? _observers.remove(key)
          : _observers[key]!.removeWhere((l) => l.callBack == listener);
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
    if (_observers[key] == null)
      _observers[key] = LinkedList<MyLinkedListEntry<VoidCallback>>();
    return _observers[key]!.isNotEmpty;
  }

  List<String> get getListenersKeys {
    return _observers.keys.toList();
  }

  void dispose() {
    _observers.clear();
  }
}

class MyLinkedListEntry<T>
    extends LinkedListEntry<MyLinkedListEntry<VoidCallback>> {
  VoidCallback callBack;
  MyLinkedListEntry(this.callBack);
  @override
  String toString() => '${super.toString()}: $callBack';
}
