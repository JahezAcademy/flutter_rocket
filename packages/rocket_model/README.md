# Rocket Model 🚀

[![pub package](https://img.shields.io/pub/v/rocket_model.svg)](https://pub.dev/packages/rocket_model)
[![license](https://img.shields.io/github/license/JahezAcademy/mvc_rocket.svg)](LICENSE)

A **type‑safe, reactive model layer** for Flutter/Dart that works hand‑in‑hand with `rocket_client` for data fetching and `rocket_view` for UI rendering. Define your data models once, get automatic JSON (de)serialization, state handling, and listener notifications.

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  rocket_model: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## 🎯 Quick Start

```dart
import 'package:rocket_model/rocket_model.dart';
import 'package:rocket_client/rocket_client.dart';
import 'package:rocket_view/rocket_view.dart';
```

## 🛠️ Rocket CLI

It is **highly recommended** to use [rocket_cli](https://pub.dev/packages/rocket_cli) to generate your models. It automates the creation of boilerplate code, including `fromJson`, `toJson`, and field definitions.

**Installation:**

```bash
dart pub global activate rocket_cli
```

**Usage Example:**

Generate a model from a JSON string:

```bash
rocket_cli -j '{"id": 1, "title": "My Post", "body": "Content"}' -n Post
```

Or from a file:

```bash
rocket_cli -f post.json -n Post
```


### 1️⃣ Define a model

```dart
const String postTitleField = "title";

class Post extends RocketModel<Post> {
  int? userId;
  int? id;
  String? title;
  String? body;

  Post({this.userId, this.id, this.title, this.body});

  void updateFields({String? titleField}) {
    List<String> fields = [];
    if (titleField != null) {
      title = titleField;
      fields.add(postTitleField);
    }
    rebuildWidget(fromUpdate: true, fields: fields.isEmpty ? null : fields);
  }

  @override
  void fromJson(Map<String, dynamic> json, {bool isSub = false}) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
    super.fromJson(json, isSub: isSub);
  }

  @override
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };

  @override
  get instance => Post();
}
```

### 2️⃣ Load data with `rocket_client`

Initialize your client and save it to the Rocket singleton:

```dart
void main() {
  final client = RocketClient(url: 'https://jsonplaceholder.typicode.com');
  Rocket.add('posts-api', client);
  runApp(MyApp());
}
```

### 3️⃣ Show data with `rocket_view`

```dart
class PostList extends StatelessWidget {
  final Post post = Post();

  @override
  Widget build(BuildContext context) {
    return RocketView(
      model: post,
      // call the api using the client key
      fetch: () => Rocket.get<RocketClient>('posts-api').request('posts', model: post),
      builder: (context, state) {
        return ListView.builder(
          itemCount: post.all!.length,
          itemBuilder: (_, i) {
            final p = post.all![i];
            return ListTile(
              title: Text(p.title ?? ''),
              subtitle: Text(p.body ?? ''),
            );
          },
        );
      },
    );
  }
}
```

The view automatically rebuilds when the model notifies listeners via `rebuildWidget()`.

## 🛠️ API Overview

| Class / Member | Description |
|----------------|-------------|
| **`RocketModel<T>`** (abstract) | Base class for all models. Implements `RocketListenable` for reactive updates. |
| `instance` | Factory getter that returns a fresh instance of the concrete model. |
| `all` | List of all loaded items of type `T`. |
| `fromJson(Map<String, dynamic> json, {bool isSub})` | Populate the model from a JSON map. |
| `toJson()` | Serialize the model back to JSON. |
| `addItem(T item)` | Append a new item to `all` and notify listeners. |
| `delItem(int index)` | Remove an item by index and notify listeners. |
| `setMulti(List<T> data)` | Replace the entire collection with a new list. |
| `setException(RocketException e)` | Store an error that occurred during loading. |
| `rebuildWidget({bool fromUpdate = false})` | Trigger a UI rebuild for listeners. |
| **`RocketState`** (enum) | Loading lifecycle: `loading`, `done`, `failed`. |

### Key Properties

- `instance` – concrete model factory.
- `all` – current collection of items.
- `exception` – holds any loading error.
- `state` – current `RocketState`.

## 🤝 Contributing

We welcome contributions! Open issues or submit pull requests on the [GitHub repository](https://github.com/JahezAcademy/mvc_rocket). Helpful contributions include:

- New model examples.
- Improved documentation or tutorials.
- Bug fixes or API extensions.

## 📄 License

This package is released under the MIT License – see the [LICENSE](LICENSE) file for details.
