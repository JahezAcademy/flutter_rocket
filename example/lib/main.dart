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
        title: 'MVR Package',
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
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              example(context, "Counter View", "counter"),
              example(context, "10 Users", "user"),
              example(context, "100 Posts", "post"),
              example(context, "5000 Photos", "photo")
            ],
          ),
        ),
      ),
    );
  }

  Widget example(BuildContext context, String title, String to) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(title),
          onPressed: () => Navigator.pushNamed(context, "/$to")),
    );
  }
}
