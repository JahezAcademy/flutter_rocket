import 'dart:collection';
import 'dart:ui';

import 'package:rocket_listenable/src/extensions.dart';

import 'custom_linked_list.dart';

/// An abstract class that defines the behavior of a listenable object.
///
/// A listenable object allows other objects to register and unregister listeners,
/// and can notify its listeners when a change occurs.
abstract class RocketListenable {
  final HashMap<String, LinkedList<CustomLinkedListEntry<VoidCallback>>>
      _observers = HashMap();

  /// A list of RocketListenable objects that this object is merged with.
  List<RocketListenable> merges = [];

  /// Returns true if this object is merged with other objects.
  bool get isMerged {
    return merges.isNotEmpty;
  }

  /// Registers a new listener with the specified key.
  void registerListener(String key, VoidCallback listener) {
    if (_observers[key] == null) {
      _observers[key] = LinkedList<CustomLinkedListEntry<VoidCallback>>();
    }
    _observers[key]!.add(CustomLinkedListEntry(listener));
  }

  /// Registers multiple listeners with the specified keys.
  void registerListeners(Map<String, List<VoidCallback>> listeners) {
    listeners.forEach((key, value) {
      for (var element in value) {
        _observers[key] ??= LinkedList();
        _observers[key]!.add(CustomLinkedListEntry(element));
      }
    });
  }

  /// Notifies the listeners registered with the specified key.
  void callListener(String key) {
    if (_observers.containsKey(key)) {
      for (var l in _observers[key]!) {
        l.callBack.call();
      }
    }
  }

  /// Notifies the listeners registered with any of the specified keys.
  void callListeners(List<String> keys) {
    for (var key in keys) {
      callListener(key);
    }
  }

  /// Removes the specified listener (or all listeners if no listener is specified) with the specified key.
  void removeListener(String key, [VoidCallback? listener]) {
    if (_observers.containsKey(key)) {
      if (listener == null) {
        _observers.remove(key);
      } else {
        _observers[key]!.removeWhere((l) => l.callBack == listener);
        if (_observers[key]!.isEmpty) {
          _observers.remove(key);
        }
      }
    }
  }

  /// Removes the specified listeners (or all listeners if no listener is specified) with the specified keys.
  void removeListeners(List<String> keys, [List<VoidCallback>? listeners]) {
    for (var key in keys) {
      removeListener(key);
    }
    if (listeners != null) {
      _observers.forEach((key, value) {
        value.removeWhere((l) => listeners.contains(l.callBack));
      });
    }
  }

  /// Returns true if this object has any listeners.
  bool get hasListeners {
    return _observers.isNotEmpty;
  }

  /// Returns true if a listener is registered with the specified key.
  bool keyHasListeners(String key) {
    if (_observers[key] == null) {
      _observers[key] = LinkedList<CustomLinkedListEntry<VoidCallback>>();
    }
    return _observers[key]!.isNotEmpty;
  }

  /// Returns a list of all keys that have registered listeners.
  List<String> get getListenersKeys {
    return _observers.keys.toList();
  }

  /// Disposes of this object and removes all listeners.
  void dispose() {
    _observers.clear();
  }
}
