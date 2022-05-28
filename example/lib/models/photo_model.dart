import 'package:mvc_rocket/mvc_rocket.dart';

class Photo extends RocketModel<Photo> {
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

  void fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    albumId = json['albumId'] ?? albumId;
    id = json['id'] ?? id;
    title = json['title'] ?? title;
    url = json['url'] ?? url;
    thumbnailUrl = json['thumbnailUrl'] ?? thumbnailUrl;
    super.fromJson(json, isSub: isSub);
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

  @override
  get instance => Photo();
}
