import 'package:mc/mc.dart';

class Photo extends McModel<Photo> {
  List<Photo> multi;
  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

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

  void setMulti(List data) {
    List listOfphoto = data.map((e) {
      Photo photo = Photo();
      photo.fromJson(e);
      return photo;
    }).toList();
    multi = listOfphoto;
  }
}

