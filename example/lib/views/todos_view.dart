import 'package:example/models/todos.dart';
import 'package:example/requests/todos.dart';
import 'package:flutter/material.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

class TodosExample extends StatelessWidget {
  TodosExample({Key? key, required this.title}) : super(key: key);
  final String title;

  final todos = Todos();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: RocketView(
        model: todos,
        call: () => GetTodos.gettodos(todos),
        builder: (context) {
          return ListView.builder(
            itemCount: todos.multi!.length,
            itemBuilder: (context, int index) {
              final todo = todos.multi![index];
              return CheckboxListTile(
                title: Text(todo.title!),
                value: todo.completed,
                onChanged: (value) {
                  todo.updateFields(completedField: value);
                },
              );
            },
          );
        },
      ),
    );
  }
}
