# Rocket MiniView 🚀

[![pub package](https://img.shields.io/pub/v/rocket_mini_view.svg)](https://pub.dev/packages/rocket_mini_view)
[![license](https://img.shields.io/github/license/JahezAcademy/mvc_rocket.svg)](LICENSE)

A tiny, **reactive** widget that rebuilds automatically when a `RocketListenable` (e.g. `RocketValue`) changes. It lives in the `rocket_listenable` ecosystem and lets you write concise, declarative UI code without boilerplate.

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  rocket_mini_view: ^0.0.1
```

Then fetch the packages:

```bash
flutter pub get
```

## 🎯 Getting Started

Import the widget:

```dart
import 'package:rocket_mini_view/rocket_mini_view.dart';
```

### Simple example

```dart
import 'package:flutter/material.dart';
import 'package:rocket_listenable/rocket_listenable.dart';
import 'package:rocket_mini_view/rocket_mini_view.dart';

final RocketValue<List<String>> items = RocketValue([]);

class CounterDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MiniView Demo')),
      body: Center(
        child: RocketMiniView(
          value: items,
          builder: () => Text('Items count: ${items.value.length}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => items.value = [...items.value, 'Item ${items.value.length + 1}'],
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

The `builder` runs each time `items` changes, giving you an instantly‑updating UI.

## 🛠️ API Overview

| Class / Constructor | Description |
|---------------------|-------------|
| `RocketMiniView({Key? key, required RocketListenable<T> value, required Widget Function() builder})` | Core widget that listens to `value` and rebuilds using `builder`. |
| `MiniViewRocketState` | Internal `State` implementation – handles subscription lifecycle (`initState`, `didUpdateWidget`, `dispose`). |
| `_rebuildWidget()` | Private helper called when the listened object notifies listeners. |
| `build(BuildContext context)` | Returns the widget produced by `builder`. |

### Parameters
- **`value`** – The `RocketListenable` (e.g. `RocketValue`, `RocketListenable`) you want to observe.
- **`builder`** – A zero‑argument function that returns the widget tree to render.
- **`key`** – Optional widget key.

## 🤝 Contributing

Feel free to open issues or submit pull requests on the [GitHub repository](https://github.com/JahezAcademy/mvc_rocket). Contributions that add examples, improve documentation, or extend functionality are especially welcome.

## 📄 License

This package is released under the MIT License – see the [LICENSE](LICENSE) file for details.
