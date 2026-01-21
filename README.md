# <img width="40" height="40" alt="logo-2" src="https://github.com/user-attachments/assets/d89f912e-fac9-4341-845e-dc33d70ee70c" /> Flutter Rocket

**The ultimate power-up for your Flutter state management and API integration.**

[![Pub](https://img.shields.io/pub/v/flutter_rocket.svg)](https://pub.dartlang.org/packages/flutter_rocket)
[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Flutter CI](https://github.com/JahezAcademy/flutter_rocket/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/JahezAcademy/flutter_rocket/actions/workflows/flutter-ci.yml)

Flutter Rocket is a high-performance, lightweight state management and API integration solution. It simplifies how you handle data from your backend to your UI while providing premium performance optimizations out of the box.

---

## 🚀 Key Features

-   ⚡ **Ultra Performance**: Selective rebuilds ensure only necessary widgets update.
-   🔗 **Seamless API Integration**: Built-in client with support for interceptors and caching.
-   🛠️ **Powerful Tooling**: Generate optimized models instantly using [Rocket CLI](https://pub.dev/packages/rocket_cli).
-   📉 **Minimal Boilerplate**: Write less code, build more features.
-   📦 **Modular Architecture**: Use only what you need (Listenables, Models, Clients, Views).
-   🛡️ **Type Safe**: Fully typed models and requests.

---

## 📦 Package Ecosystem

| Package | Version | Description |
| --- | --- | --- |
| [flutter_rocket](https://pub.dev/packages/flutter_rocket) | [![pub package](https://img.shields.io/pub/v/flutter_rocket.svg)](https://pub.dev/packages/flutter_rocket) | Core bundle for Flutter. |
| [rocket_model](https://pub.dev/packages/rocket_model) | [![pub package](https://img.shields.io/pub/v/rocket_model.svg)](https://pub.dev/packages/rocket_model) | Base model and state logic. |
| [rocket_client](https://pub.dev/packages/rocket_client) | [![pub package](https://img.shields.io/pub/v/rocket_client.svg)](https://pub.dev/packages/rocket_client) | HTTP client with caching. |
| [rocket_view](https://pub.dev/packages/rocket_view) | [![pub package](https://img.shields.io/pub/v/rocket_view.svg)](https://pub.dev/packages/rocket_view) | UI state management widgets. |
| [rocket_cli](https://pub.dev/packages/rocket_cli) | [![pub package](https://img.shields.io/pub/v/rocket_cli.svg)](https://pub.dev/packages/rocket_cli) | CLI for model generation. |

---

## 📖 Table of Contents
- [Graphic Tutorial](#-graphic-tutorial)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Core Concepts](#-core-concepts)
    - [RocketModel](#rocketmodel)
    - [RocketClient](#rocketclient)
    - [RocketView](#rocketview)
- [Premium Optimizations](#-premium-optimizations)
    - [Selective Rebuilds](#selective-rebuilds)
    - [Automatic Bubbling](#automatic-bubbling)
- [Advanced Features](#-advanced-features)
    - [Interceptors](#interceptors)
    - [Caching](#caching)
- [Rocket CLI](#-rocket-cli)

---

## 🎨 Graphic Tutorial

![Flutter Rocket Architecture](https://github.com/user-attachments/assets/b60a34bd-e480-4e6b-81af-1bb9905c0017)

[Explore the Miro Board](https://miro.com/app/board/uXjVJal1g3o=/?share_link_id=335195782321)

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_rocket: ^latest_version
```

---

## ⚡ Quick Start

### 1. Define your Model
Use **Rocket CLI** to generate this automatically, or define it manually:

```dart
import 'package:flutter_rocket/flutter_rocket.dart';

const String postTitleField = "title";

class Post extends RocketModel<Post> {
  String? title;

  Post({this.title});

  @override
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if (json == null) return;
    title = json[postTitleField];
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({String? titleField}) {
    List<String> fields = [];
    if (titleField != null) {
      title = titleField;
      fields.add(postTitleField);
    }
    rebuildWidget(fromUpdate: true, fields: fields.isEmpty ? null : fields);
  }

  @override
  Post get instance => Post();
}
```

### 2. Setup the Client
Initialize your client and save it to the Rocket singleton:

```dart
void main() {
  RocketRequest request = RocketRequest(url: 'https://jsonplaceholder.typicode.com');
  Rocket.add(rocketRequestKey, request);
  runApp(MyApp());
}
```

### 3. Bind UI with RocketView
Display your data effortlessly:

```dart
class PostList extends StatelessWidget {
  final Post postModel = Post();

  @override
  Widget build(BuildContext context) {
    return RocketView(
      model: postModel,
      fetch: () => Rocket.get(rocketRequestKey).request('posts', model: postModel),
      builder: (context, state) {
        return ListView.builder(
          itemCount: postModel.all!.length,
          itemBuilder: (context, index) {
            final post = postModel.all![index];
            return Text(post.title!);
          },
        );
      },
    );
  }
}
```

---

## ✨ Premium Optimizations

### Selective Rebuilds
Stop rebuilding your entire list when only one item changes. Specify fields in `RocketView` to listen to specific property updates.

```dart
RocketView(
  model: currentPost,
  fields: [postTitleField], // Only rebuilds when 'title' changes
  builder: (context, state) => Text(currentPost.title!),
)
```

### Automatic Bubbling
Nested models automatically notify their parents. If a `Post` inside a `Posts` list updates, the list view is notified automatically without any extra code.

---

## 🛠️ Advanced Features

### Interceptors
Handle global logic like Auth headers or logging:

```dart
RocketClient(
  url: 'https://api.example.com',
  beforeRequest: (request) {
    request.headers['Authorization'] = 'Bearer your_token';
    return request;
  },
);
```

### Caching
Speed up your app with built-in caching:

```dart
RocketCache.init(); // Initialize first

client.request(
  'posts',
  model: post,
  cacheKey: 'all_posts',
  cacheDuration: Duration(days: 1),
);
```

---

## 🛠️ Rocket CLI

Generate your optimized models instantly from JSON strings or files.

```bash
# Install
dart pub global activate rocket_cli

# Run
rocket_cli -j '{"id":1, "title":"Hello"}' -n Post
```

---

## 🔗 Links & Support

| Resource | Link |
| --- | --- |
| **Documentation** | [Wiki](https://github.com/JahezAcademy/flutter_rocket/wiki) |
| **Examples** | [GitHub Examples](https://github.com/JahezAcademy/flutter_rocket/tree/main/example) |
| **Community** | [Discussions](https://github.com/JahezAcademy/flutter_rocket/discussions) |
| **Bugs** | [Issue Tracker](https://github.com/JahezAcademy/flutter_rocket/issues) |

# Author
Built with ❤️ by the **[Jahez Team](https://github.com/JahezAcademy)**.
