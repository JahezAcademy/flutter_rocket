import 'package:flutter/material.dart';
import '../Models/counter_model.dart';
import 'package:mc/mc.dart';

class CounterExample extends StatelessWidget {
  final String title;
  CounterExample({required this.title});
  final Counter counter = Counter();
  @override
  Widget build(BuildContext context) {
    // mc.add(sizeDesign, Size(100, 200));
    // mc.add(sizeScreen, Size(context.width, context.height));
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        //width: 10.w,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Number of once call parameter called & you can also click on add icon',
              textAlign: TextAlign.center,
            ),
            McView(
              model: counter,
              // call & secondsOfStream & callType optional parameters you can use McView Widget without them
              call: add,
              //callType: CallType.callAsStream,
              secondsOfStream: 1,
              builder: (context) {
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
        backgroundColor: Theme.of(context).primaryColor,
        //change your field by json structure
        onPressed: () {
          counter.count -= 1;
          counter.fromJson({"count": counter.count});
        },
        tooltip: 'Increment',
        child: Icon(Icons.minimize),
      ),
    );
  }

  Future<void> add() async {
    await Future.delayed(Duration(seconds: 2));
    counter.count += 50;
    print(50);
  }
}
