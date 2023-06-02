import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rocket/rocket.dart';

class MiniView extends StatelessWidget {
  MiniView({Key? key, required this.title}) : super(key: key);
  final String title;
  final RocketValue<String> rocketString = "Initial value".mini;
  final RocketValue<int> rocketNum = 5.mini;
  final RocketValue<List> rocketList = [].mini;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("use View for every value"),
            RocketMiniView(
                value: rocketString, builder: () => Text(rocketString.v)),
            RocketMiniView(
              value: rocketNum,
              builder: () => Text(rocketNum.v.toString() +
                  (rocketNum.v.toString() == "11"
                      ? " click to remove listener"
                      : "")),
            ),
            RocketMiniView(
              value: rocketList,
              builder: () {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      itemCount: rocketList.v.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                            child: Text(rocketList.v[index].toString()));
                      },
                    ));
              },
            ),
            const SizedBox(
              height: 60.0,
            ),
            const Text("merge multiple values"),
            RocketMiniView(
              value: RocketValue.merge([rocketString, rocketNum, rocketList]),
              builder: () => Wrap(
                runAlignment: WrapAlignment.center,
                children: [
                  Text(rocketString.v),
                  const Text("=>"),
                  Text(rocketNum.v.toString()),
                  const Text("=>"),
                  Text(rocketList.v.toString())
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          rocketNum.v++;
          rocketString.v = "Value Changed";
          // dont use methods for add items or remove it use instead of it +/-
          rocketList.v += [rocketNum.v, rocketString.v];
          if (rocketNum.v == 6) {
            rocketNum.registerListener(rocketMiniRebuild, valChanged);
            rocketNum.registerListener(rocketMergesRebuild, () {
              log('this listener called when widget of merges values rebuild');
            });
          }
          if (rocketNum.v == 12) {
            rocketNum.removeListener(rocketMiniRebuild, valChanged);
            log("listener removed!!!");
          }
        },
        tooltip: 'change Value',
        child: const Icon(Icons.change_circle),
      ),
    );
  }

  valChanged() {
    log('this listener called when widget of mcNum rebuild');
  }
}

// class MiniViewRocket extends StatelessWidget {
//   final RocketValue<String> myStringValue = "My Value".mini;
//   final RocketValue<int> myIntValue = 2021.mini;

//   MiniViewRocket({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // use RocketValue for every widget
//           RocketMiniView(
//             value: myStringValue,
//             builder: () => Text(myStringValue.v),
//           ),
//           RocketMiniView(
//             value: myStringValue,
//             builder: () => Text(myIntValue.v.toString()),
//           ),
//           const SizedBox(
//             height: 25.0,
//           ),
//           // merge multi RocketValue in one widget
//           RocketMiniView(
//               value: RocketValue.merge([myStringValue, myIntValue]),
//               builder: () {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text(myStringValue.v),
//                     Text(myIntValue.v.toString())
//                   ],
//                 );
//               })
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Theme.of(context).primaryColor,
//         onPressed: () {
//           // change value
//           myStringValue.v = "Value Changed";
//           myIntValue.v = 2022;
//         },
//         tooltip: 'change Value',
//         child: const Icon(Icons.change_circle),
//       ),
//     );
//   }
// }
