import 'dart:io';

import 'package:example/models/post_model.dart';
import 'package:example/requests/post_request.dart';
import 'package:flutter/material.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

class PostExample extends StatelessWidget {
  // Save your model to use on another screen
  // readOnly means if you close and open this screen you will use same data without update it from Api
  // [rocket] is instance of Mccontroller injected in Object by extension for use it easily anywhere
  final Post post =
      RocketController().add<Post>(postsEndpoint, Post(), readOnly: true);

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
                onPressed: () => GetPosts.getPosts(post))
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
              onRefresh: () {
                return GetPosts.getPosts(post);
              },
              child: RocketView(
                // call api method
                call: () => GetPosts.getPosts(post),
                // your model generated
                model: post,
                // call call Voidcallback if model empty
                callType: CallType.callIfModelEmpty,
                // or
                // callType: CallType.callAsStream,
                // secondsOfStream: 1,
                // customized your loading (default widget is CircularProgressIndicator)
                // loader:CustomLoading(),

                // handle errors
                onError: (RocketException exception, Function() reload) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(exception.exception),
                        if (exception.statusCode != HttpStatus.ok) ...[
                          Text(exception.response),
                          Text(rocket
                              .get(rocketRequestKey)
                              .msgByStatusCode(exception.statusCode))
                        ],
                        TextButton(onPressed: reload, child: Text("retry"))
                      ],
                    ),
                  );
                },
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
}

class Details extends StatelessWidget {
  final int index;
  //  get your model by key
  final Post post = RocketController().get<Post>(postsEndpoint);
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
