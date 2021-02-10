import 'package:flutter/material.dart';
import '../Models/CounterModel.dart';
import 'package:mc/mc.dart';


class MyHomePage extends StatelessWidget {
  final String title;
   MyHomePage({this.title});
  final Counter counter = Counter();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            McView(
              model: counter,
              builder: (BuildContext context, Widget child) {
                return Text(
                  counter.count.toString(),
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //change your field by json structure
        onPressed: ()=>counter.fromJson({"count": counter.count + 1}),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
