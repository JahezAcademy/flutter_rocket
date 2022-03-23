import 'package:mvc_rocket/mvc_rocket.dart';

class Photo extends RocketModel<Photo> {
  List<Photo>? multi;
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  String albumIdVar = "albumId";
  String idVar = "id";
  String titleVar = "title";
  String urlVar = "url";
  String thumbnailUrlVar = "thumbnailUrl";
  Photo({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  void fromJson(covariant Map<String, dynamic> json) {
    albumId = json['albumId'] ?? albumId;
    id = json['id'] ?? id;
    title = json['title'] ?? title;
    url = json['url'] ?? url;
    thumbnailUrl = json['thumbnailUrl'] ?? thumbnailUrl;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['albumId'] = this.albumId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['thumbnailUrl'] = this.thumbnailUrl;

    return data;
  }

  void setMulti(List data) {
    List<Photo> listOfphotos = data.map((e) {
      Photo photos = Photo();
      photos.fromJson(e);
      return photos;
    }).toList();
    multi = listOfphotos;
  }
}
