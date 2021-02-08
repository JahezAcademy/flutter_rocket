# mc

State managment and request package, Model,View,Request [MVR].

## Author: [CHAHBOUN Mohammed](https://github.com/m97chahboun)


[![Pub](https://img.shields.io/pub/v/mc.svg)](https://pub.dartlang.org/packages/mc)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Getting Started

In your flutter project, add the dependency to your `pubspec.yaml`

```yaml
dependencies:
  ...
  mc: ^0.0.1
```

## Usage
```dart
/////////////////////////////-- Model --/////////////////////////////
// for generate The appropriate model by json data use this tool [https://github.com/ourflutter/Json2Dart]
import 'package:mc/mc.dart';

class Post extends McModel{
 int userId;
 int id;
 String title;
 String body;
List multi = [];
 Post({
  this.userId,
  this.id,
  this.title,
  this.body,
 });

 fromJson(Map<String, dynamic> json) {
  userId = json['userId'];
  id = json['id'];
  title = json['title'];
  body = json['body'];
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
void setMulti(List d) {
    List r = d.map((e) {
      Post m = Post();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }
/////////////////////////////-- View --/////////////////////////////
mport 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:mcMVRexample/Request.dart';

import 'PostModel.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({this.title});
  final String title;
  final Post post = Post();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.get_app),
        onPressed:()=>request.getObjData("posts", post,multi:true)
      ),
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: McView(
            model: post,
            builder: (BuildContext context, Widget child) {
              return ListView.builder(
                itemCount: post.multi.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    title:Text(post.multi[index].title),
                    children:[
                      SizedBox(height:5.0),
                      Text(post.multi[index].body)
                    ]
                  );
                },
              );
            },
          )),
    );
  }
/////////////////////////////-- Request --/////////////////////////////
import 'package:mc/mc.dart';

String baseUrl = 'https://jsonplaceholder.typicode.com/';

McRequest request = McRequest(url: baseUrl);
```
# License
    MIT License
    
    Copyright (c) 2020 Mohammed CHAHBOUN
    
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
