import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
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
  final ValueNotifier<double> dx = ValueNotifier<double>(0.1);
  BuildContext cntx;
  List<String> exps = [
    "Mc Package",
    "Link your app with API easily",
    "One Package All Features",
    "Make your work easy",
    "this animation make by crazy code with for loop"
  ];
  int index = 0;
  MyApp() {
    String baseUrl = 'https://jsonplaceholder.typicode.com';
    McRequest request = McRequest(url: baseUrl);
    mc.add('rq', request);
    for (var i = 0; i < 9; i++) {
      Timer.periodic(Duration(milliseconds: 80), (timer) {
        if (dx.value <=
            MediaQuery.of(cntx).size.width +
                (MediaQuery.of(cntx).size.width * 0.04)) {
          dx.value += 0.5;
        } else {
          dx.value = -MediaQuery.of(cntx).size.width;
          if (index < exps.length - 1) {
            index++;
          } else {
            index = 0;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    cntx = context;
    return Scaffold(
      body: Center(
        child: Container(
          height: context.h * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ValueListenableBuilder(
                  valueListenable: dx,
                  builder: (context, _, __) {
                    return Transform.translate(
                      offset: Offset(dx.value, 1),
                      //dx: dx.value,
                      child: Text(
                        exps[index],
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
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
