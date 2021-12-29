import 'package:mc/mc.dart';

class Post extends McModel<Post> {
  int? userId;
  int? id;
  String? title;
  String? body;

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
  fromJson(covariant Map<String, dynamic> json) {
    userId = json['userId'] ?? userId;
    id = json['id'] ?? id;
    title = json['title'] ?? title;
    body = json['body'] ?? body;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;

    return data;
  }
}
