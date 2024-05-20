import 'package:flutter/material.dart';
import 'package:rocket_singleton/rocket_singleton.dart';

void main() {
  runApp(const MyApp());
}

/// Represents a rocket model.
class RocketModel {
  final String name;
  final int fuelCapacity;

  RocketModel({required this.name, required this.fuelCapacity});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final models = [
    RocketModel(name: 'Falcon 9', fuelCapacity: 10000),
    RocketModel(name: 'Saturn V', fuelCapacity: 20000),
    RocketModel(name: 'Delta IV', fuelCapacity: 15000),
  ];

  @override
  void initState() {
    // Add each model to the Rocket class's internal collection.
    for (final model in models) {
      Rocket.add(model, key: model.name, readOnly: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the Falcon 9 model from the Rocket class.
    final falcon9 = Rocket.get<RocketModel>('Falcon 9');

    return MaterialApp(
      title: 'Rocket App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rocket App'),
        ),
        body: Center(
          child: Text(
            'The Falcon 9 has a fuel capacity of ${falcon9.fuelCapacity} gallons.',
          ),
        ),
      ),
    );
  }
}
