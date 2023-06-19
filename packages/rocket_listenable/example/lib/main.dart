import 'package:example/controller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Listenable Counter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RocketListenableCounterExample(),
    );
  }
}

/// A screen that displays a counter and allows the user to increment and decrement it.
class RocketListenableCounterExample extends StatefulWidget {
  const RocketListenableCounterExample({super.key});

  @override
  RocketListenableCounterExampleState createState() =>
      RocketListenableCounterExampleState();
}

class RocketListenableCounterExampleState
    extends State<RocketListenableCounterExample> {
  final CounterController _counter = CounterController();

  @override
  void initState() {
    super.initState();

    // Register this widget as a listener for the 'valueChanged' event.
    _counter.registerListener('valueChanged', _onValueChanged);
  }

  @override
  void dispose() {
    // Unregister this widget as a listener to avoid memory leaks.
    _counter.removeListener('valueChanged', _onValueChanged);
    super.dispose();
  }

  /// Callback method that is called when the counter value changes.
  void _onValueChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Listenable Counter Example'),
      ),
      body: Center(
        child: Text(
          '${_counter.value}',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _counter.increment,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _counter.decrement,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
