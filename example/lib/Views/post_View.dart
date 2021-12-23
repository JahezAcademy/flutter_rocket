import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import '../Models/PostModel.dart';

class PostExample extends StatelessWidget {
  // Save your model to use on another screen
  // readOnly means if you close and open this screen you will use same data without update it from Api
  // [mc] is instance of Mccontroller injected in Object by extension for use it easily anywhere
  final Post post = McController().add<Post>('posts', Post(), readOnly: true);
  // get request by key
  final McRequest request = McController().get<McRequest>("rq");
  PostExample({required this.title});
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
          child: RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: McView(
                // call api method
                call: () => request.getObjData("posts", post, multi: true),
                // your model generated
                model: post,
                // handle errors
                onError: (McException exception,Function() reload) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(exception.exception),
                        Text(exception.response),
                        TextButton(onPressed: reload, child: Text("retry"))
                      ],
                    ),
                  );
                },
                // call api if model is empty & you can choose another ways like default way asFuture(call once) & asStream (call every //[secondsOfStream] seconds)
                callType: CallType.callIfModelEmpty,
                // or
                // callType: CallType.callAsStream,
                // secondsOfStream: 1,
                // customized your loading (default widget is CircularProgressIndicator)
                // loader:CustomLoading(),
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.852,
                    child: ListView.builder(
                      itemCount: post.multi!.length,
                      itemBuilder: (BuildContext context, int index) {
                        // your data saved in multi list as Post model
                        Post currentPost = post.multi![index];
                        return ListTile(
                            leading: Text(currentPost.id.toString()),
                            title: Text(currentPost.title!),
                            onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return Details(index);
                                  }),
                                ));
                      },
                    ),
                  );
                },
              )),
        ));
  }

  Future<dynamic> refresh() {
    // use hrrp method you want (get,post,put) + ObjData if you used model in McView and you can use JsonData for get data directly from api
    return request.getObjData(
      // endpoint
      "posts",
      // your model
      post,
      // if you received data as List multi will be true & if data as map you not should to define multi its false as default
      multi: true,
      // parameters for send it with request
      // params:{"key":"value"},
      // inspect method for determine exact json use for generate your model in first step
      // if your api send data directly without any supplement values you not should define it
      // inspect:(data)=>data["response"]
    );
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
      appBar: AppBar(title: Text(post.multi![index].title!)),
      body: Center(
        child: ListTile(
          leading: Text(post.multi![index].id.toString()),
          title: Text(post.multi![index].title!),
          subtitle: Text(post.multi![index].body!),
        ),
      ),
    );
  }
}
