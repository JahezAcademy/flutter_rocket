
import 'package:rocket_model/rocket_model.dart';

class Post extends RocketModel<Post> {
  int id = 0;
  String title = "";
  String body = "";

  @override
  void fromJson(json, {bool isSub = false}) {
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
    body = json['body'] ?? "";
    super.fromJson(json, isSub: isSub);
  }

  @override
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body};

  @override
  get instance => Post();
}
