# Rocket MiniView

`RocketMiniView` is a widget provided by the `rocket_listenable` package that listens to changes in a `RocketListenable` object and rebuilds when a change occurs. It is designed to be used in conjunction with `RocketValue` objects to build reactive UIs in Flutter.

## Usage

To use `RocketMiniView`, import it into your Dart file:

```dart
import 'package:flutter/material.dart';
import 'package:rocket_listenable/rocket_listenable.dart';
import 'package:your_app/constants.dart';

import 'rocket_mini_view.dart';

final RocketValue value = [].mini;
...
RocketMiniView(
  value: value,
  builder: () {
    return Text(value.length.toString());
  },
)
```

The `RocketMiniView` widget takes two required parameters:

- `value`: The `RocketListenable` object to listen to.
- `builder`: A function that returns the widget tree to build.

The `builder` function should return the widget tree that needs to be rebuilt when the `RocketListenable` object changes.

## API Reference

### `RocketMiniView`

The `RocketMiniView` widget is a widget that listens to changes in a `RocketListenable` object and rebuilds when a change occurs.

#### Constructor

```dart
RocketMiniView({
  Key? key,
  required this.value,
  required this.builder,
})
```

- `key`: An optional `Key` object to use for the widget.
- `value`: The `RocketListenable` object to listen to.
- `builder`: A function that returns the widget tree to build.

#### `MiniViewRocketState`

The `MiniViewRocketState` class is the state object for the `RocketMiniView` widget.

#### `initState` Method

```dart
void initState()
```

Called when the widget is first inserted into the widget tree.

#### `didUpdateWidget` Method

```dart
void didUpdateWidget(RocketMiniView oldWidget)
```

Called when the widget is updated with new parameters.

#### `dispose` Method

```dart
void dispose()
```

Called when the widget is removed from the widget tree.

#### `_rebuildWidget` Method

```dart
void _rebuildWidget()
```

Called when the `RocketListenable` object changes.

#### `build` Method

```dart
Widget build(BuildContext context)
```

Builds the widget tree using the `builder` function.

## Conclusion

`RocketMiniView` is a useful widget provided by the `rocket_listenable` package that enables you to build reactive UIs in Flutter. Its simple API and ability to listen to changes in `RocketListenable` objects make it an ideal choice for building Flutter applications that need to react to changes in data.