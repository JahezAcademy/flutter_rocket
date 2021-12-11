import 'package:flutter/material.dart';
import 'package:mc/mc.dart';

class MiniView extends StatelessWidget {
  MiniView({this.title});
  final String title;
  final McValue<String> mcString = "Initial value".mini;
  final McValue<int> mcNum = 5.mini;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
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
          const SizedBox(
            height: 60.0,
          ),
          Text("merge multiple values"),
          McMiniView(
              () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mcString.v),
                      Text("=>"),
                      Text(mcNum.v.toString())
                    ],
                  ),
              McValue.merge([mcString, mcNum])),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        //change your field by json structure
        onPressed: () {
          mcNum.v++;
          mcString.v = "Value Changed";
          if (mcNum.v == 6) {
            mcNum.registerListener("valueChanged", valChanged);
            mcNum.registerListener("mergesChanged", () {
              print(
                  'this listener called when widget of merges values rebuild');
            });
          }
          if (mcNum.v == 12) {
            mcNum.removeListener("valueChanged", valChanged);
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
