import 'package:flutter/material.dart';
import 'package:rocket_mini_view/rocket_mini_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RocketMiniViewExample(),
    );
  }
}

class RocketMiniViewExample extends StatelessWidget {
  final RocketValue _value = 0.mini;
  final RocketValue _mergedValue = 100.mini;

  RocketMiniViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket MiniView Example'),
      ),
      body: Center(
        child: RocketMiniView(
          value: RocketValue.merge([_value, _mergedValue]),
          builder: () {
            return Text(
              'value : ${_value.v} - merged value : ${_mergedValue.v}',
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              _value.v = _value.v + 1;
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              _mergedValue.v = _mergedValue.v + 1;
            },
            child: const Icon(Icons.merge),
          ),
        ],
      ),
    );
  }
}
