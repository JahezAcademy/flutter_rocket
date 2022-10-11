#  🚀 MVCRocket 🚀

State management and request package, Model,View,Controller,Request MVCR.

# Author: [Jahez team](https://github.com/JahezAcademy)

[![Pub](https://img.shields.io/pub/v/rocket.svg)](https://pub.dartlang.org/packages/mvc_rocket)
[![License: MIT](https://img.shields.io/badge/License-MIT-brown.svg)](https://opensource.org/licenses/MIT)
[![Flutter CI](https://github.com/JahezAcademy/mvc_rocket/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/JahezAcademy/mvc_rocket/actions/workflows/flutter-ci.yml)

# Usage
## Simple case use RocketMiniView & RocketValue
its very simple

```dart
class McMiniViewExample extends StatelessWidget {
  // use mini for convert value to RocketValue
  final RocketValue<String> myStringValue = "My Value".mini;
  final RocketValue<int> myIntValue = 2021.mini;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // use your value in RocketMiniView and if value changed will rebuild widget for show your new value
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // use value for every widget
            RocketMiniView(myStringValue, () => Text(myStringValue.v)),
            RocketMiniView(myStringValue, () => Text(myIntValue.v.toString())),
            const SizedBox(
              height: 25.0,
            ),
            // merge multi values in one widget
            RocketMiniView(RocketValue.merge([myStringValue, myIntValue]), () {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(myStringValue.v),
                  Text(myIntValue.v.toString())
                ],
              );
            })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          // change value
          myStringValue.v = "Value Changed";
          myIntValue.v = 2022;
        },
        tooltip: 'change Value',
        child: Icon(Icons.change_circle),
      ),
    );
  }
}

```

## Complex case (state management & request)

firstly you need to create your model by your json data from this [Link](https://json2dart.web.app/)
you get something like this:

```dart
import 'package:mvc_rocket/mvc_rocket.dart';

String postUserIdField = "userId";
String postIdField = "id";
String postTitleField = "title";
String postBodyField = "body";

class Post extends RocketModel<Post> {
  int? userId;
  int? id;
  String? title;
  String? body;
  // disable logs debugging
  @override
  bool get enableDebug => true;
  Post({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  @override
  void fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    userId = json[postUserIdField] ?? userId;
    id = json[postIdField] ?? id;
    title = json[postTitleField] ?? title;
    body = json[postBodyField] ?? body;
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
    int? userIdField,
    int? idField,
    String? titleField,
    String? bodyField,
  }) {
    userId = userIdField ?? userId;
    id = idField ?? id;
    title = titleField ?? title;
    body = bodyField ?? body;
    rebuildWidget();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[postUserIdField] = userId;
    data[postIdField] = id;
    data[postTitleField] = title;
    data[postBodyField] = body;

    return data;
  }

  @override
  get instance => Post();
}

```

Now second step create your RocketRequest in constructor or initState of first widget and pass url & headers

```dart
class MyApp extends StatelessWidget {
  MyApp() {
    const String baseUrl = 'https://jsonplaceholder.typicode.com';
    // create request object
    RocketRequest request = RocketRequest(url: baseUrl);
    // save it, for use it from any screen by key
    Rocket.add(rocketRequestKey, request);    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
    );
  }
}...
```

Now create request method for post

```dart
import 'package:example/models/post_model.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

const String postsEndpoint = "posts";

class GetPosts {
  static Future getPosts(Post postModel) =>
      Rocket.get(rocketRequestKey).getObjData(
        // endpoint
        postsEndpoint,
        // your model
        postModel,
        // if you received data as List multi will be true & if data as map you not should to define multi its false as default
        multi: true,
        // parameters for send it with request
        // params:{"key":"value"},
        // inspect method for determine exact json use for generate your model in first step
        // if your api send data directly without any supplement values you not should define it
        // inspect:(data)=>data["response"]
      );
}
```

Next step its build [RocketView] Widget & pass your [RocketModel] in [model] & [RocketRequest] method in [call] parameter

```dart
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
      Rocket.add<Post>(postsEndpoint, Post(), readOnly: true);

  PostExample({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Refresh Posts with swip to down or from here =>",
            style: TextStyle(fontSize: 11.0),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.data_usage),
                // Refresh Data from Api
                onPressed: () => GetPosts.getPosts(post))
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
              onRefresh: ()=> GetPosts.getPosts(post),
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
                        TextButton(
                            onPressed: reload, child: const Text("retry"))
                      ],
                    ),
                  );
                },
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.852,
                    child: ListView.builder(
                      itemCount: post.multi!.length,
                      itemBuilder: (BuildContext context, int index) {
                        // your data saved in multi list as Post model
                        Post currentPost = post.multi![index];
                        return ListTile(
                            leading: Text(currentPost.id.toString()),
                            title: Text(currentPost.title!),
                            trailing: IconButton(
                              color: Colors.brown,
                              icon: const Icon(Icons.update),
                              onPressed: () {
                                // update post data
                                currentPost.updateFields(
                                  bodyField: "This Body changed",
                                  titleField: "This Title changed"
                                );
                              },
                            ),
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
  final Post post = Rocket.get<Post>(postsEndpoint);
  Details(this.index, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Post currentPost = post.multi![index];
    return Scaffold(
      appBar: AppBar(title: Text(currentPost.title!)),
      body: Center(
        child: ListTile(
          leading: Text(currentPost.id.toString()),
          title: Text(currentPost.title!),
          subtitle: Text(currentPost.body!),
        ),
      ),
    );
  }
}
```

& last item its McController for save your model or any value and get it anywhere by key

```dart
// inside of object use mc extension 
McController().add("key",value,readOnly:true); // you can't edit it if readonly true
// or
// [add] return value
Rocket.add<Type>("key",value);
// [get] return value
Rocket.get<Type>("key");
// [remove]
Rocket.remove("key");
// remove with condition
Rocket.removeWhere((key,value)=>key.contains("ke"));

```
## Graphic tutorial 
![JPG](https://github.com/JahezAcademy/mvc_rocket/blob/MVCRocket/mvcRocket_package.jpg)
[explain graphic](https://miro.com/welcomeonboard/cjY2OWRqRGFZMnZLRXBSemdZZmF2NkduZXdlMkJOenRaaWJ2cXhUejVXenByYVFSZ2F4YkxhMDBVaDZTcExzRHwzMDc0NDU3MzY0OTgzODE0OTU3?invite_link_id=677217465426)
## [More examples](https://github.com/JahezAcademy/mvc_rocket/tree/main/example)
# License
    MIT License
    
    Copyright (c) 2022 Jahez team
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
