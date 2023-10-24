import 'package:example/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rocket/flutter_rocket.dart';
import 'package:go_router/go_router.dart';

void main() {
  configureRequest();
  runApp(const App());
}

void configureRequest() {
  const String baseUrl = 'https://jsonplaceholder.typicode.com';
  // create request object
  RocketClient request = RocketClient(url: baseUrl);
  // save it, for use from any screen
  Rocket.add(request);
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: '🚀 Rocket Package 🚀',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final ValueNotifier<double> dx = ValueNotifier<double>(0.1);
  int index = 0;
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Rocket Package 🚀'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: context.height * 0.8,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '🚀 Rocket Package 🚀',
                style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
              Example("Mini View", "miniView"),
              Example("Counter View", "counter"),
              Example("10 Users", "users"),
              Example("100 Posts", "posts"),
              Example("5000 Photos", "photos"),
              Example("200 Todos", "todos"),
            ],
          ),
        ),
      ),
    );
  }
}

class Example extends StatelessWidget {
  final String title, to;
  const Example(this.title, this.to, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.6,
      height: context.height * 0.1,
      child: TextButton(
          key: Key(to),
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.brown),
          ),
          onPressed: () => context.go("/$to", extra: title)),
    );
  }
}

extension SizeDevice on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}
