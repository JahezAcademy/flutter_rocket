// Import necessary packages and files
import 'package:example/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:rocket_view/rocket_view.dart';

void main() {
  // Run the app by instantiating a MyApp widget
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // The root widget of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // Define the theme for the app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set the home property to RocketViewExample
      home: RocketViewExample(),
    );
  }
}

class RocketViewExample extends StatelessWidget {
  // Instantiate a Todo object
  final Todo todos = Todo();

  RocketViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RocketView Example'),
      ),
      // Add a floating action button to add new Todos to the list
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          todos.addItem(Todo(
            title: 'New Todo',
            completed: false,
          ));
        },
        label: const Text("New Todo"),
        icon: const Icon(Icons.add),
      ),
      // Use the RocketView widget to manage state for the Todo list
      body: RocketView(
        // Pass the Todo object to the RocketView widget as the model
        model: todos,
        // Define how the Todo list should be displayed
        builder: (context, state) {
          return ListView.builder(
            itemCount: todos.all!.length,
            itemBuilder: (context, index) {
              final item = todos.all![index];
              return ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.delete),
                  // Delete the Todo when the user taps the delete icon
                  onPressed: () {
                    todos.delItem(index);
                  },
                ),
                title: TextField(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: TextEditingController(text: item.title),
                  // Update the title of the Todo when the user submits a change
                  onSubmitted: (value) {
                    item.updateFields(titleField: value);
                  },
                ),
                trailing: Checkbox(
                  value: item.completed,
                  // Update the completed status of the Todo when the user taps the checkbox
                  onChanged: (bool? value) {
                    item.updateFields(completedField: value);
                  },
                ),
                // Update the completed status of the Todo when the user taps the list tile
                onTap: () =>
                    item.updateFields(completedField: !item.completed!),
              );
            },
          );
        },
        // Define how the Todo list should be fetched
        call: todos.fetch,
        callType: CallType.callAsFuture,
        // Define how to handle errors
        onError: (error, reload) => Text('Error: ${error.exception}'),
        // Add a loading indicator while the Todo list is being fetched
        loader: const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
