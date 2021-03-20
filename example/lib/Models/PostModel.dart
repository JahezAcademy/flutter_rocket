import 'package:mc/mc.dart';
class Post extends McModel{
 List multi;
 int userId;
 int id;
 String title;
 String body;

 Post({
  this.userId,
  this.id,
  this.title,
  this.body,
 }){


  multi = multi ?? [];
}
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

void setMulti(List d) {
        List r = d.map((e) {
          Post m = Post();
          m.fromJson(e);
          return m;
            }).toList();
            multi = r;
          }

}
