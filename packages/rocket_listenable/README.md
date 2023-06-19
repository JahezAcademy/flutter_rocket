# Rocket Listenable

A package that provides a mix-in `RocketListenable` class for implementing listenable objects in Dart.

A listenable object allows other objects to register and unregister listeners and can notify its listeners when a change occurs.

## Usage

To use the `RocketListenable` class, simply extend your class with it and call the `registerListener` method to register a listener. Call the `callListener` method to notify the listeners that a change has occurred.

```dart
import 'package:rocket_listenable/rocket_listenable.dart';

class MyModel with RocketListenable {
  String _data = '';

  String get data => _data;

  set data(String value) {
    _data = value;
    callListener('data');
  }
}

final myModel = MyModel();

myModel.registerListener('data', () {
  print('Data changed: ${myModel.data}');
});

myModel.data = 'Hello, world!';
```

## Methods

### `registerListener(String key, VoidCallback listener)`

Registers a new listener with the specified `key`.

### `registerListeners(Map<String, List<VoidCallback>> listeners)`

Registers multiple listeners with the specified `keys`.

### `callListener(String key)`

Notifies the listeners registered with the specified `key`.

### `callListeners(List<String> keys)`

Notifies the listeners registered with any of the specified `keys`.

### `removeListener(String key, [VoidCallback? listener])`

Removes the specified `listener` (or all listeners if no listener is specified) with the specified `key`.

### `removeListeners(List<String> keys, [List<VoidCallback>? listeners])`

Removes the specified `listeners` (or all listeners if no listener is specified) with the specified `keys`.

### `hasListeners`

Returns `true` if this object has any listeners.

### `keyHasListeners(String key)`

Returns `true` if a listener is registered with the specified `key`.

### `getListenersKeys`

Returns a list of all keys that have registered listeners.

### `dispose()`

Disposes of this object and removes all listeners.