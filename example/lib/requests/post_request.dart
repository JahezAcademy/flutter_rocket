import 'package:example/models/post_model.dart';
import 'package:mc/mc.dart';

class GetPosts {
  static Future getPosts(Post post) =>
      McController().get<McRequest>('rq').getObjData(
        // endpoint
        "posts",
        // your model
        post,
        inspect: (d) {
          print(d);
          return d;
        },
        // if you received data as List multi will be true & if data as map you not should to define multi its false as default
        multi: true,
        // parameters for send it with request
        // params:{"key":"value"},
        // inspect method for determine exact json use for generate your model in first step
        // if your api send data directly without any supplement values you not should define it
        // inspect:(data)=>data["response"]
      );
}
