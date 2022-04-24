import 'package:mvc_rocket/mvc_rocket.dart';

class Post extends RocketModel<Post> {
  int? userId;
  int? id;
  String? title;
  String? body;
  // disable logs debugging
  @override
  bool get enableDebug => false;
  String userIdVar = "userId";
  String idVar = "id";
  String titleVar = "title";
  String bodyVar = "body";
  Post({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  @override
  void fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    userId = json['userId'] ?? userId;
    id = json['id'] ?? id;
    title = json['title'] ?? title;
    body = json['body'] ?? body;
    return super.fromJson(json, isSub: isSub);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;

    return data;
  }

  @override
  void setMulti(List data) {
    List<Post> listOfpost = data.map((e) {
      Post post = Post();
      post.fromJson(e, isSub: true);
      return post;
    }).toList();
    multi = listOfpost;
    super.setMulti(data);
  }


}
