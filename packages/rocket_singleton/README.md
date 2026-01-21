# Rocket Singleton 🚀

[![pub package](https://img.shields.io/pub/v/rocket_singleton.svg)](https://pub.dev/packages/rocket_singleton)
[![license](https://img.shields.io/github/license/JahezAcademy/mvc_rocket.svg)](LICENSE)

A lightweight, type‑safe singleton utility for Flutter/Dart that lets you **store** and **retrieve** objects in memory by **type** or **custom key**.  
It works without any boilerplate, supports read‑only values, and provides convenient extension methods.

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  rocket_singleton: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## 🎯 Getting Started

Import the package:

```dart
import 'package:rocket_singleton/rocket_singleton.dart';
```

### Saving values

```dart
// Using the extension on any object
final post = Post()
    .save(key: 'post', readOnly: true); // readOnly prevents further edits

// Directly via the Rocket singleton
Rocket.add(post, readOnly: true);

// Storing multiple objects of the same type with a custom key
Rocket.add<Post>(post, key: 'featuredPost');
```

### Retrieving values

```dart
// By key (type inference)
final savedPost = Rocket.get<Post>('post');

// By type only – returns the first matching instance
final anyPost = Rocket.get<Post>();
```

### Removing values

```dart
// Remove a specific entry
Rocket.remove('post');

// Remove by condition
Rocket.removeWhere((key, value) => key.startsWith('temp_'));
```

## 🛠️ API Overview

| Method | Description |
|--------|-------------|
| `Rocket.add<T>(T value, {String? key, bool readOnly = false})` | Store a value. If `key` is omitted, the type is used as the identifier. |
| `Rocket.get<T>([String? key])` | Retrieve a value by key or by type. |
| `Rocket.remove(String key)` | Delete a stored entry. |
| `Rocket.removeWhere(bool Function(String key, dynamic value) predicate)` | Delete entries that match a predicate. |
| `T.save({String? key, bool readOnly = false})` *(extension)* | Shortcut to add the object to the singleton. |

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request on the [GitHub repository](https://github.com/JahezAcademy/mvc_rocket).

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.
