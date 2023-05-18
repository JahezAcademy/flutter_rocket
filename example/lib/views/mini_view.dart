import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

class MiniView extends StatelessWidget {
  MiniView({Key? key, required this.title}) : super(key: key);
  final String title;
  final RocketValue<String> mcString = "Initial value".mini;
  final RocketValue<int> mcNum = 5.mini;
  final RocketValue<List> mcList = [].mini;
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
            RocketMiniView(value: mcString, builder: () => Text(mcString.v)),
            RocketMiniView(
              value: mcNum,
              builder: () => Text(mcNum.v.toString() +
                  (mcNum.v.toString() == "11"
                      ? " click to remove listener"
                      : "")),
            ),
            RocketMiniView(
              value: mcList,
              builder: () {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      itemCount: mcList.v.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(child: Text(mcList.v[index].toString()));
                      },
                    ));
              },
            ),
            const SizedBox(
              height: 60.0,
            ),
            const Text("merge multiple values"),
            RocketMiniView(
              value: RocketValue.merge([mcString, mcNum, mcList]),
              builder: () => Wrap(
                runAlignment: WrapAlignment.center,
                children: [
                  Text(mcString.v),
                  const Text("=>"),
                  Text(mcNum.v.toString()),
                  const Text("=>"),
                  Text(mcList.v.toString())
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          mcNum.v++;
          mcString.v = "Value Changed";
          // dont use methods for add items or remove it use instead of it +/-
          mcList.v += [mcNum.v, mcString.v];
          if (mcNum.v == 6) {
            mcNum.registerListener(rocketMiniRebuild, valChanged);
            mcNum.registerListener(rocketMergesRebuild, () {
              log('this listener called when widget of merges values rebuild');
            });
          }
          if (mcNum.v == 12) {
            mcNum.removeListener(rocketMiniRebuild, valChanged);
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
