import 'package:flutter/material.dart';
import 'Views/CounterView.dart';
import 'Views/PhotoView.dart';
import 'Views/PostView.dart';
import 'Views/UserView.dart';

void main() {
  runApp(MaterialApp(
      routes: <String, WidgetBuilder>{
        '/counter': (BuildContext context) => new CounterExample(
              title: "Counter",
            ),
        '/user': (BuildContext context) => new UserExample(
              title: "10 User",
            ),
        '/post': (BuildContext context) => new PostExample(
              title: "100 Post",
            ),
        '/photo': (BuildContext context) => new PhotoExample(
              title: "5000 Photo",
            ),
      },
      title: 'MVR Package',
      theme: ThemeData(
        primaryColor: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              example(context, "Counter View", "counter"),
              example(context, "10 User", "user"),
              example(context, "100 Post", "post"),
              example(context, "5000 Photo", "photo")
            ],
          ),
        ),
      ),
    );
  }

  Widget example(BuildContext context, String title, String to) {
    return RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(title),
        onPressed: () => Navigator.pushNamed(context, "/$to"));
  }
}
