import 'package:flutter/material.dart';
import 'Views/CounterView.dart';
import 'Views/PhotoView.dart';
import 'Views/PostView.dart';
import 'Views/UserView.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: <String, WidgetBuilder>{
          '/counter': (BuildContext context) => new CounterExample(
                title: "Counter",
              ),
          '/user': (BuildContext context) => new UserExample(
                title: "10 Users",
              ),
          '/post': (BuildContext context) => new PostExample(
                title: "100 Posts",
              ),
          '/photo': (BuildContext context) => new PhotoExample(
                title: "5000 Photos",
              ),
        },
        title: 'MVCR Package',
        theme: ThemeData(
          primaryColor: Colors.brown,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: context.h * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Example("Counter View", "counter"),
              Example("10 Users", "user"),
              Example("100 Posts", "post"),
              Example("5000 Photos", "photo")
            ],
          ),
        ),
      ),
    );
  }
}

class Example extends StatelessWidget {
  final String title, to;
  Example(this.title, this.to);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w * 0.6,
      height: context.h * 0.1,
      child: TextButton(
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          onPressed: () => Navigator.pushNamed(context, "/$to")),
    );
  }
}

extension SizeDevice on BuildContext {
  double get h => MediaQuery.of(this).size.height;
  double get w => MediaQuery.of(this).size.width;
}
