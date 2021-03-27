import 'package:mc/mc.dart';

class Photo extends McModel {
  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;
  List multi;

  Photo({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  }) {
    multi = multi ?? [];
  }
  fromJson(Map<String, dynamic> json) {
    albumId = json['albumId'] ?? albumId;
    id = json['id'] ?? id;
    title = json['title'] ?? title;
    url = json['url'] ?? url;
    thumbnailUrl = json['thumbnailUrl'] ?? thumbnailUrl;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['albumId'] = this.albumId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['thumbnailUrl'] = this.thumbnailUrl;

    return data;
  }

  void setMulti(List d) {
    List r = d.map((e) {
      Photo m = Photo();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }
}
