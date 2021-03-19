import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import '../Request/Request.dart';
import '../Models/PostModel.dart';

//Use as you like
///with [FutureBuilder]
/////## multi[true]
///
///
///
class PostExample extends StatelessWidget {
  PostExample({this.title});
  final String title;
  final PostC _con = PostC();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: request.getObjData("posts", _con.post, multi: true),
            builder: (BuildContext __, _) {
              return ListView.builder(
                itemCount: _con.post.multi.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text(_con.post.multi[index].id.toString()),
                    title: Text(_con.post.multi[index].title),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Details(index);
                    })),
                  );
                },
              );
            },
          )),
    );
  }
}

class Details extends StatelessWidget {
  final int index;
  Details(this.index);
  final PostC _con = PostC();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListTile(
          leading: Text(_con.post.multi[index].id.toString()),
          title: Text(_con.post.multi[index].title),
          subtitle: Text(_con.post.multi[index].body),
        ),
      ),
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
