# mc

MVCRocket State management and request package, Model,View,Controller,Request MVCR.

# Author: [Mohammed CHAHBOUN](https://github.com/m97chahboun)


[![Pub](https://img.shields.io/pub/v/rocket.svg)](https://pub.dartlang.org/packages/mc)
[![License: MIT](https://img.shields.io/badge/License-MIT-brown.svg)](https://opensource.org/licenses/MIT)

# Getting Started

In your flutter project, add the dependency to your `pubspec.yaml`

```yaml
dependencies:
  ...
  mc: ^0.0.2
```
# Usage
## Simple case use McMV & RocketValue
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
        //use your value in McMV and if value changed will rebuild widget for show your new value
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // use value for every widget
            McMV(myStringValue, () => Text(myStringValue.v)),
            McMV(myStringValue, () => Text(myIntValue.v.toString())),
            const SizedBox(
              height: 25.0,
            ),
            // merge multi values in one widget
            McMV(RocketValue.merge([myStringValue, myIntValue]), () {
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

firstly you need to create your  cket from your json data by this [Link](https://json2dart.web.app/)
you get something like this:

```dart
import 'package:mc/mvc_rocket.dart';

class Post extends RocketModel<Post> {
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

Now second step create your RocketRequest in constructor or initState of first widget and pass url & headers

```dart
class MyApp extends StatelessWidget {
  MyApp() {
    const String baseUrl = 'https://jsonplaceholder.typicode.com';
    // create request object
    RocketRequest request = RocketRequest(url: baseUrl);
    // save it, for use it from any screen by key
    rocket.add('request', request);    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
    );
  }
}...
```

Next step its build [RocketView] Widget & pass your [RocketModel] in [model] & [RocketRequest] method in [call] parameter


```dart

class PostExample extends StatelessWidget {
  // Save your model to use on another screen
  // readOnly means if you close and open this screen you will use same data without update it from Api
  // [mc] is instance of Mccontroller injected in Object by extension for use it easily anywhere
  final Post post = McController().add<Post>('posts', Post(), readOnly: true);
  // get request by key
  final RocketRequest request = McController().get<RocketRequest>("request");
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
          child: RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: RocketView(
                // call api method
                // i write post endpoint incorrect for produce an error & use onError builder
                call: () => request.getObjData("posqts", post, multi: true),
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
                        // reload is method for call api again (call parameter)
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
                loader:CustomLoading(),
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.852,
                    child: ListView.builder(
                      itemCount: post.multi.length,
                      itemBuilder: (BuildContext context, int index) {
                        // your data saved in multi list as Post model
                        Post currentPost = post.multi[index];
                        return ListTile(
                            leading: Text(post.id.toString()),
                            title: Text(post.title),
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
    // use http method you want (get,post,put) + ObjData if you used model in RocketView and you can use JsonData for get data directly from api
    return request.getObjData(
    // endpoint
    "posts",
    // your model
    post, 
    // if you received data as List multi will be true & if data as map you not should to define multi its false as default
    multi: true,
    // parameters for send it with request
    params:{"key":"value"},
    // inspect method for determine exact json use for generate your model in first step
    // if your api send data directly without any supplement values you not should define it
    inspect:(data)=>data["response"]
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
rocket.add<Type>("key",value);
// [get] return value
rocket.get<Type>("key");
// [remove]
rocket.remove("key");
// remove with condition
rocket.removeWhere((key,value)=>key.contains("ke"));

```
## Graphic tutorial 
![JPG](https://github.com/OurFlutterC/mc/blob/staging/mc_package.jpg)
[explain graphic](https://miro.com/welcomeonboard/cjY2OWRqRGFZMnZLRXBSemdZZmF2NkduZXdlMkJOenRaaWJ2cXhUejVXenByYVFSZ2F4YkxhMDBVaDZTcExzRHwzMDc0NDU3MzY0OTgzODE0OTU3?invite_link_id=677217465426)
## [More examples](https://github.com/ourflutter/mc/tree/main/example)
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
