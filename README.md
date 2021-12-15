# mc

State management and request package, Model,View,Controller,Request MVCR.

# Author: [Mohammed CHAHBOUN](https://github.com/m97chahboun)


[![Pub](https://img.shields.io/pub/v/mc.svg)](https://pub.dartlang.org/packages/mc)
[![License: MIT](https://img.shields.io/badge/License-MIT-brown.svg)](https://opensource.org/licenses/MIT)

# Getting Started

In your flutter project, add the dependency to your `pubspec.yaml`

```yaml
dependencies:
  ...
  mc: ^0.0.2+1
```
# Usage
## Simple case use McMV & McValue
its very simple

```
class McMiniViewExample extends StatelessWidget {
  // use mini for convert value to McValue
  final McValue<String> myValue = "My Value".mini;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //use your value in McMV and if value changed will rebuild widget for show your new value
        child: McMV(myValue, () => Text(myValue.v)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          // change value
          myValue.v = "Value Changed";
        },
        tooltip: 'change Value',
        child: Icon(Icons.change_circle),
      ),
    );
  }
}

```

## Complex case (state management & request)

firstly you need to create your McModel from your json data by this [Link](https://json2dart.web.app/)
you get something like this:

```
import 'package:mc/mc.dart';

class Post extends McModel<Post> {
  List<Post> multi;
  int userId;
  int id;
  String title;
  String body;

  final String userIdStr = 'userId';
  final String idStr = 'id';
  final String titleStr = 'title';
  final String bodyStr = 'body';

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

Now second step create your McRequest in constructor or initState of first widget and pass url & headers

```
class MyApp extends StatelessWidget {
  MyApp() {
    const String baseUrl = 'https://jsonplaceholder.typicode.com';
    // create request object
    McRequest request = McRequest(url: baseUrl);
    // save it, for use it from any screen by screen
    mc.add('request', request);    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
    );
  }
}...
```

Next step its build [McView] Widget & pass your [McModel] in [model] & [McRequest] method in [call] parameter


```
class PostExample extends StatelessWidget {
  // Save your model to use on another screen
  // readOnly means if you close and open this screen you will use same data without update it from Api
  // [mc] is instance of Mccontroller injected in Object by extension for use it easily anywhere
  final Post post = McController().add<Post>('posts', Post(), readOnly: true);
  // get request by key
  final McRequest request = McController().get<McRequest>("request");
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
            call: () => request.getObjData("posqts", post, multi: true),
            model: post,
            onError: (McException exception) {
              return Column(
                children: [Text(exception.exception), Text(exception.response)],
              );
            },
            // call api if model is empty
            callType: CallType.callIfModelEmpty,
            loader:CustomLoading(),
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
    return request.getObjData("posts", post, multi: true);
  }
}
```
& last item its McController for save your model or any value and get it anywhere by key

```
// inside of object use mc extension 
McController().add("key",value,readOnly:true); // you can't edit it if readonly true
// or
// add
mc.add<Type>("key",value);
// get
mc.get<Type>("key");
// remove
mc.remove<Type>("key");
// remove with condition
mc.removeWhere<Type>((key,value)=>key.contains("ke"));

```

## [More examples](https://github.com/ourflutter/mc/tree/main/example)
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
