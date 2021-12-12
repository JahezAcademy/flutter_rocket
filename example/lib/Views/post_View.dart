import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import '../Models/PostModel.dart';

class PostExample extends StatelessWidget {
  // Save your model to use on another screen
  // readOnly means if you close and open this screen you will use same data without update it from Api
  // [mc] is instance of Mccontroller injected in Object by extension for use it easily anywhere
  final Post post = McController().add<Post>('posts', Post(), readOnly: true);
  final McRequest rq = McController().get<McRequest>("rq");
  PostExample({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Refresh Posts with swip to down or from here =>",
          style: TextStyle(fontSize: 11.0),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.data_usage),
              // Refresh Data from Api
              onPressed: () => refresh())
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: McView(
            call: () => rq.getObjData("posts", post, multi: true),
            model: post,
            onError: (t, m) {
              return t != null && m != null
                  ? Column(
                      children: [Text(t), Text(m.toString())],
                    )
                  : Text("error");
            },
            // call api if model is empty
            callType: CallType.callIfModelEmpty,
            builder: (context) {
              return RefreshIndicator(
                onRefresh: () {
                  return refresh();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.852,
                  child: ListView.builder(
                    itemCount: post.multi.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Text(post.multi[index].id.toString()),
                        title: Text(post.multi[index].title),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Details(index);
                        })),
                      );
                    },
                  ),
                ),
              );
            },
          )),
    );
  }

  Future<dynamic> refresh() {
    return rq.getObjData("posts", post, multi: true);
  }
}

class Details extends StatelessWidget {
  final int index;
  //get your model by key
  final Post post = McController().get<Post>('posts');
  Details(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.multi[index].title)),
      body: Center(
        child: ListTile(
          leading: Text(post.multi[index].id.toString()),
          title: Text(post.multi[index].title),
          subtitle: Text(post.multi[index].body),
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
//           builder: () {
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
//             builder: () {
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
//             builder: () {
//               return ExpansionTile(
//                   title: Text(post.title),
//                   children: [SizedBox(height: 5.0), Text(post.body)]);
//             },
//           )),
//     );
//   }
// }

// as Request Json || Model
// ## multi[false]
// Json: request.getJsonData("posts/1").then((value) => print(value));
// Model: request.getObjData("posts/1",yourModelHere).then((value) => print(value));
// ## multi[true]
// Json: request.getJsonData("posts",multi: true).then((value) => print(value));
// Model: request.getObjData("posts",yourModelHere,multi: true).then((value) => print(value));
