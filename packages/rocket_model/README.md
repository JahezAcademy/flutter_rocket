<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

RocketModel get data from [RocketClient](https://pub.dev/packages/rocket_client) & Show it with [RocketView](https://pub.dev/packages/rocket_view)

## Features

- support multi models (get from `all` field)
- support states (loading, done, failed)
- support update fields
- support rebuild widget

## Getting started

Model generate from here 

## Usage

```dart
import 'package:flutter_rocket/rocket.dart';

const String postUserIdField = "userId";
const String postIdField = "id";
const String postTitleField = "title";
const String postBodyField = "body";

class Post extends RocketModel<Post> {
  int? userId;
  int? id;
  String? title;
  String? body;
  // disable logs debugging
  @override
  bool get enableDebug => true;
  Post({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  @override
  void fromJson(Map<String, dynamic> json, {bool isSub = false}) {
    userId = json[postUserIdField];
    id = json[postIdField];
    title = json[postTitleField];
    body = json[postBodyField];
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
    int? userIdField,
    int? idField,
    String? titleField,
    String? bodyField,
  }) {
    userId = userIdField ?? userId;
    id = idField ?? id;
    title = titleField ?? title;
    body = bodyField ?? body;
    rebuildWidget(fromUpdate: true);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[postUserIdField] = userId;
    data[postIdField] = id;
    data[postTitleField] = title;
    data[postBodyField] = body;

    return data;
  }

  @override
  get instance => Post();
}

```

