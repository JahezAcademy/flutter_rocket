# mc

State management and request package, Model,View,Controller,Request [MVCR].

## Author: [Mohammed CHAHBOUN](https://github.com/m97chahboun)


[![Pub](https://img.shields.io/pub/v/mc.svg)](https://pub.dartlang.org/packages/mc)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Getting Started

In your flutter project, add the dependency to your `pubspec.yaml`

```yaml
dependencies:
  ...
  mc: ^0.0.1+9
```
for generate The appropriate model by json data use this website https://json2dart.web.app/

## Usage

/////////////////////////////-- Model --/////////////////////////////

```dart
import 'package:mc/mc.dart';


class Post extends McModel<Post> {
  List<Post> multi;
  int userId;
  int id;
  String title;
  String body;

  Post({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? userId;
    id = json['id'] ?? id;
    title = json['title'] ?? title;
    body = json['body'] ?? body;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }

  void setMulti(List data) {
    List listOfpost = data.map((e) {
      Post post = Post();
      post.fromJson(e);
      return post;
    }).toList();
    multi = listOfpost;
  }
}

```
/////////////////////////////-- View --/////////////////////////////
```dart

import 'package:mc/mc.dart';
import 'Request.dart';
import 'PostModel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVCR Package',
      theme: ThemeData(
        primaryColor: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'MVCR Package'),
    );
  }
}

class PostExample extends StatelessWidget {
  // Save your model to use on another screen
  // (!) means if you close and open this screen you will use same data without update it from Api
  // [mc] is instance of Mccontroller injected in Stateless and ful widget by extension for use it easily
  final Post post = McController().add<Post>('!posts', Post());
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
              onPressed: () => rq.getObjData("posts", post, multi: true))
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: McView(
            call: () => rq.getObjData("posts", post, multi: true),
            model: post,
            callType: CallType.callIfModelEmpty,
            builder: (BuildContext __, snp) {
              return RefreshIndicator(
                onRefresh: () => rq.getObjData("posts", post, multi: true),
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
              );
            },
          )),
    );
  }
}
```
/////////////////////////////////--Another View to use same data--////////////////////////////////// 
```dart
import 'package:mc/mc.dart';
import 'Request.dart';
import 'PostModel.dart';
import 'package:flutter/material.dart';

/////We will use same data on this page by controller
class Details extends StatelessWidget {
  final int index;
  Post post;
  //you can it directly here or in constractor with mc
  //Post post = McController().get<Post>('posts')
  Details(this.index) {
    //get your model by key
    post = mc.get<Post>("posts");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
```
/////////////////////////////-- Request --/////////////////////////////
```dart
import 'package:mc/mc.dart';

//your url with http or https protocol
String baseUrl = 'jsonplaceholder.typicode.com';
String token = "4acabed770cf............................";
Map<String, String> apiHeaders = {
  "Authorization": "Token " + token,
  "Content-Type": "application/json",
  "Accept": "application/json, text/plain, */*",
  "X-Requested-With": "XMLHttpRequest",
};
McRequest request = McRequest(url: baseUrl);
// Save request object in controller for use it in another screen add (!) if you want to set readonly for this object 
McController('!request',request)
```

## [More example](https://github.com/ourflutter/mc/tree/main/example)
# License
    MIT License
    
    Copyright (c) 2021 Mohammed CHAHBOUN
    
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
