import 'package:example/models/post_model.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

const String postsEndpoint = "posts";

class GetPosts {
  static Future getPosts(Post postModel) {
    return Rocket.get(rocketRequestKey).request(
      // endpoint
      postsEndpoint,
      // your model
      model: postModel,
      inspect: (d) {
        return d;
      },
      // parameters for send it with request
      // params:{"key":"value"},
      // inspect method for determine exact json use for generate your model in first step
      // if your api send data directly without any supplement values you not should define it
      // inspect:(data)=>data["response"]
    );
  }
}
