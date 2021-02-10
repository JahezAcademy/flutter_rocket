import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import '../Request/Request.dart';
import '../Models/PostModel.dart';

//Use as you like
//as state management && Request
///with [FutureBuilder]
/////## multi[true]
///
///
///
class MyHomePage extends StatelessWidget {
  MyHomePage({this.title});
  final String title;
  final Post post = Post();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: request.getObjData("posts", post, multi: true),
            builder: (BuildContext context, snp) {
              print(snp.data);
              return post.loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: snp.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ExpansionTile(
                            title: Text(snp.data[index].title),
                            children: [
                              SizedBox(height: 5.0),
                              Text(snp.data[index].body)
                            ]);
                      },
                    );
            },
          )),
    );
  }
}

///////## multi[false]
///
///
// class MyHomePage extends StatelessWidget {
//   MyHomePage({this.title});
//   final String title;
//   final Post post = Post();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: FutureBuilder(
//             future: request.getObjData("posts/2", post),
//             builder: (BuildContext context, snp) {
//               print(snp.data);
//               return post.loading
//                   ? CircularProgressIndicator()
//                   : ExpansionTile(
//                       title: Text(snp.data.title),
//                       children: [SizedBox(height: 5.0), Text(snp.data.body)]);
//             },
//           )),
//     );
//   }
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


