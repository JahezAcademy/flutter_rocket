# RocketView

Rocket Model is a Flutter package that provides a way to manage the state of your data using a `RocketModel` object and display that data in a widget tree using a `RocketView` widget. The `RocketView` widget automatically handles the different states of the data (loading, done, and failed) and provides an easy way to fetch and reload data.

## Usage

Here's an example of how to use RocketView:

```dart
import 'package:flutter/material.dart';
import 'package:rocket_view/rocket_view.dart';
import 'package:example/models/todo.dart';

class TodoList extends StatelessWidget {
  final todoModel = Rocket.add(Todos(), readOnly: true);

  @override
  Widget build(BuildContext context) {
    return RocketView(
      model: todoModel,
      fetch: () => GetTodos.getTodos(todoModel),
      onLoading: () {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
      },
      onError: (error, reload) => Text('Error: ${error.exception}'),
      callType: CallType.callIfModelEmpty,
      builder: (context, state) {
        return ListView.builder(
          itemCount: todoModel.all!.length,
          itemBuilder: (context, index) {
            final todo = todoModel.all![index];
            return CheckboxListTile(
              value: todo.completed,
              title: Text(todo.title!),
              onChanged: (value) {
                todo.updateFields(completedField: value);
              },
            );
          },
        );
      },
    );
  }
}
```

In this example, `TodoList` is a Flutter widget that displays a list of Todo items using a `RocketView` widget and the `Todos` model object. The `call` method fetches Todo data using the `GetTodos` static method, and the `builder` method displays a `CheckboxListTile` widget for each Todo item. The `onChanged` callback updates the `completed` field of the Todo item when the checkbox is clicked.

## [RocketModel](https://pub.dev/packages/rocket_model)

The `RocketModel` class is a base class for model objects that are used with `RocketView`. It provides methods for updating and serializing the model object, and handles widget rebuilding when the model object is updated.

Here's an example of the `Todos` class generated from [rocket2dart](https://json2dart.web.app/#):

```dart
class Todos extends RocketModel<Todos> {
  int? userId;
  int? id;
  String? title;
  bool? completed;

  Todos({
    this.userId,
    this.id,
    this.title,
    this.completed,
  });

  @override
  void fromJson(Map<String, dynamic> json, {bool isSub = false}) {
    userId = json[todosUserIdField];
    id = json[todosIdField];
    title = json[todosTitleField];
    completed = json[todosCompletedField];
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
    int? userIdField,
    int? idField,
    String? titleField,
    bool? completedField,
  }) {
    userId = userIdField ?? userId;
    id = idField ?? id;
    title = titleField ?? title;
    completed = completedField ?? completed;
    rebuildWidget(fromUpdate: true);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[todosUserIdField] = userId;
    data[todosIdField] = id;
    data[todosTitleField] = title;
    data[todosCompletedField] = completed;

    return data;
  }

  @override
  get instance => Todos();
}
```

In this example, the `Todos` class is a `RocketModel` object that has four fields (`userId`, `id`, `title`, and `completed`). It provides methods for updating the fields and serializing the Todo item.

## Conclusion

The RocketView package provides an easy way to display a model object using a builder function. It handles loading and error states, and rebuilds the widget when the model object is updated. The `RocketModel` class provides a base class for model objects that are used with `RocketView`, and provides methods for updating and serializing the model object.
