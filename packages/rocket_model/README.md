# RocketModel
RocketModel get data from [RocketClient](https://pub.dev/packages/rocket_client) & Show it with [RocketView](https://pub.dev/packages/rocket_view)

An abstract class that defines the behavior of a model object in Flutter.

A model object is a class that represents data and provides methods for managing and updating that data. The data can be stored in various forms (e.g. in-memory, in a database, or on a server) and can be accessed and manipulated through the model object's public methods.

## Features

- Provides a base class for creating model objects in Flutter.
- Allows you to define the behavior of model objects in a consistent and predictable way.
- Implements the `RocketListenable` mixin, which allows you to notify listeners when the model changes.
- Includes methods for managing and updating data, such as adding and deleting items.
- Provides hooks for handling data loading and error handling.

## Getting Started

To use `RocketModel` in your Flutter app, you'll need to import the `rocket_listenable` and `rocket_exception` packages. You can then create a new class that extends `RocketModel` and define the behavior of your model object in that class.

```dart
import 'package:flutter/foundation.dart';
import 'package:rocket_listenable/rocket_listenable.dart';

import 'constants.dart';

import 'rocket_exception.dart';

abstract class RocketModel<T> extends RocketListenable {
  // ...
}
```

Once you've created your `RocketModel` subclass, you can use it to manage and update data in your app. For example, you might use a model object to manage a list of items that you want to display in a view.

```dart
class MyItem {
  final String name;
  final String description;

  MyItem({required this.name, required this.description});
}

class MyModel extends RocketModel<MyItem> {
  MyModel() {
    // Load data from a server or database...
  }

  @override
  void fromJson(Map<String, dynamic> json, {bool isSub = false}) {
    // Deserialize data from a JSON map...
  }

  @override
  Map<String, dynamic> toJson() {
    // Serialize data to a JSON map...
    return {};
  }
}

class MyView extends StatelessWidget {
  final MyModel model = MyModel();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: model.all?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final item = model.all![index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text(item.description),
        );
      },
    );
  }
}
```

## API Documentation

### RocketModel

An abstract class that defines the behavior of a model object.

#### Properties

- `instance`: The dynamic instance of the model.
- `_loadingChecker`: A flag indicating whether the model is currently loading data.
- `existData`: A flag indicating whether the model contains any data.
- `exception`: An exception object that represents any errors that occur during data loading or manipulation.
- `all`: A list of all data objects of type `T`.
- `_state`: The current state of the model.

#### Methods

- `setException(RocketException exception)`: Sets the exception object with the given exception.
- `delItem(int index)`: Deletes the data object at the specified index.
- `addItem(T newModel)`: Adds a new data object.
- `_mapToInstance(e)`: Maps the given data to an instance of the model.
- `setMulti(List data)`: Sets the model's data to the given list of data.
- `fromJson(Map<String, dynamic> json, {bool isSub = false})`: Deserializes the model's data from the given JSON map.
- `toJson()`: Serializes the model's data to a JSON map.
- `rebuildWidget({bool fromUpdate = false})`: Notifies listeners that the model has changed and needs to be rebuilt.

### RocketState

An enum that represents the possible states of a `RocketModel` object.

#### Values

- `loading`: The model is currently loading data.
- `done`: The model has finished loading data and contains valid data.
- `failed`: An error occurred while loading or manipulating data.


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
  bool get enableDebug => false;
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

