import 'package:example/model.dart';
import 'package:flutter/material.dart';
import 'package:rocket_model/rocket_model.dart';

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
      home: const RocketModelExample(),
    );
  }
}

class RocketModelExample extends StatefulWidget {
  const RocketModelExample({super.key});

  @override
  RocketModelExampleState createState() => RocketModelExampleState();
}

class RocketModelExampleState extends State<RocketModelExample> {
  final ExampleModel _model = ExampleModel();

  @override
  void initState() {
    super.initState();
    _model.registerListener(rocketRebuild, _onModelChanged);
    _model.loadData();
  }

  @override
  void dispose() {
    _model.removeListener(rocketRebuild, _onModelChanged);
    super.dispose();
  }

  void _onModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RocketModel Example Screen'),
      ),
      body: Center(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_model.state) {
      case RocketState.loading:
        return const CircularProgressIndicator();
      case RocketState.failed:
        return Text('Failed to load data: ${_model.exception}');
      case RocketState.done:
        if (_model.existData) {
          return ListView.builder(
            itemCount: _model.all?.length,
            itemBuilder: (BuildContext context, int index) {
              final data = _model.all![index];
              return ListTile(
                leading: Text(data.id!.toString()),
                title: Text(data.name!),
              );
            },
          );
        } else {
          return const Text('No data');
        }
    }
  }
}
