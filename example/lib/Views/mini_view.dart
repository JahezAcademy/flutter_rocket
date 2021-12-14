import 'package:flutter/material.dart';
import 'package:mc/mc.dart';

class MiniView extends StatelessWidget {
  MiniView({this.title});
  final String title;
  final McValue<String> mcString = "Initial value".mini;
  final McValue<int> mcNum = 5.mini;
  final McValue<List> mcList = [].mini;
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
            Text("use View for every value"),
            McMiniView(() => Text(mcString.v), mcString),
            McMiniView(
                () => Text(mcNum.v.toString() +
                    (mcNum.v.toString() == "11"
                        ? " click to remove listener"
                        : "")),
                mcNum),
            McMiniView(() {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.builder(
                    itemCount: mcList.v.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(child: Text(mcList.v[index].toString()));
                    },
                  ));
            }, mcList),
            const SizedBox(
              height: 60.0,
            ),
            Text("merge multiple values"),
            McMiniView(
                () => Wrap(
                      runAlignment: WrapAlignment.center,
                      children: [
                        Text(mcString.v),
                        Text("=>"),
                        Text(mcNum.v.toString()),
                        Text("=>"),
                        Text(mcList.v.toString())
                      ],
                    ),
                McValue.merge([mcString, mcNum, mcList])),
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
            mcNum.registerListener(McValue.miniRebuild, valChanged);
            mcNum.registerListener(McValue.mergesRebuild, () {
              print(
                  'this listener called when widget of merges values rebuild');
            });
          }
          if (mcNum.v == 12) {
            mcNum.removeListener(McValue.miniRebuild, valChanged);
            print("listener removed!!!");
          }
        },
        tooltip: 'change Value',
        child: Icon(Icons.change_circle),
      ),
    );
  }

  valChanged() {
    print('this listener called when widget of mcNum rebuild');
  }
}
