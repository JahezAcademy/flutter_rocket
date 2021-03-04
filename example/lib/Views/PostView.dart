import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import '../Request/Request.dart';
import '../Models/PostModel.dart';

//Use as you like
///with [McView]
/////## multi[false]
///
///
///
class PostExample extends StatelessWidget {
  PostExample({this.title});
  final String title;
  final Post post = Post();
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton(
              child: Wrap(
                children: [Icon(Icons.get_app), Text("Get Data")],
              ),
              onPressed: () => request.getObjData("posts/2", post),
            ),
            FlatButton(
                child: Text("Click here to Change data"),
                onPressed: () {
                  count++;
                  post.fromJson(
                      {"title": "Change title", "body": "Change body"});
                }),
            //not required rebuild method if data not multi
          ],
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: McView(
            model: post,
            builder: (BuildContext __, _) {
              return Center(
                child: ExpansionTile(
                    title: Text(post.title + " $count"),
                    children: [
                      SizedBox(height: 5.0),
                      Text(post.body + " $count")
                    ]),
              );
            },
          )),
    );
  }
}

///////## multi[true] (FutureBuilder)
///
///
// class MyHomePage extends StatelessWidget {
//   MyHomePage({this.title});
//   final String title;
//   final Post post = Post();
//  @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(title),
//     ),
//     body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: FutureBuilder(
//           future: request.getObjData("posts", post, multi: true),
//           builder: (BuildContext context, snp) {
//             return post.loading
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: snp.data.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return ExpansionTile(
//                           title: Text(snp.data[index].title),
//                           children: [
//                             SizedBox(height: 5.0),
//                             Text(snp.data[index].body)
//                           ]);
//                     },
//                   );
//           },
//         )),
//   );
// }
// }

///// with [McView]
///// ## multi[true]
///
///
///
// class MyHomePage extends StatelessWidget {
//   MyHomePage({this.title});
//   final String title;
//   final Post post = Post();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         child:Icon(Icons.get_app),
//         onPressed:()=>request.getObjData("posts", post,multi:true)
//       ),
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: McView(
//             model: post,
//             builder: (BuildContext context, Widget child) {
//               return ListView.builder(
//                 itemCount: post.multi.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ExpansionTile(
//                     title:Text(post.multi[index].title),
//                     children:[
//                       SizedBox(height:5.0),
//                       Text(post.multi[index].body)
//                     ]
//                   );
//                 },
//               );
//             },
//           )),
//     );
//   }
// }

// //// ## multi [false]

// class MyHomePage extends StatelessWidget {
//   final String title;
//   MyHomePage({this.title});
//   final String title;
//   final Post post = Post();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.get_app),
//           onPressed: () => request.getObjData("posts/1", post)),
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: McView(
//             model: post,
//             builder: (BuildContext context, Widget child) {
//               return ExpansionTile(
//                   title: Text(post.title),
//                   children: [SizedBox(height: 5.0), Text(post.body)]);
//             },
//           )),
//     );
//   }
// }

// as Request Json & Model
// ## multi[false]
// Json: request.getJsonData("posts/1").then((value) => print(value));
// Model: request.getObjData("posts/1",yourModelHere).then((value) => print(value));
// ## multi[true]
// Json: request.getJsonData("posts",multi: true).then((value) => print(value));
// Model: request.getObjData("posts",yourModelHere,multi: true).then((value) => print(value));
