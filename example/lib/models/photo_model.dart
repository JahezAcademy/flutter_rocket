import 'package:mvc_rocket/mvc_rocket.dart';

const String photoAlbumIdField = "albumId";
const String photoIdField = "id";
const String photoTitleField = "title";
const String photoUrlField = "url";
const String photoThumbnailUrlField = "thumbnailUrl";

class Photo extends RocketModel<Photo> {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  Photo({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  @override
  void fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    albumId = json[photoAlbumIdField] ?? albumId;
    id = json[photoIdField] ?? id;
    title = json[photoTitleField] ?? title;
    url = json[photoUrlField] ?? url;
    thumbnailUrl = json[photoThumbnailUrlField] ?? thumbnailUrl;
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
    int? albumIdField,
    int? idField,
    String? titleField,
    String? urlField,
    String? thumbnailUrlField,
  }) {
    albumId = albumIdField ?? albumId;
    id = idField ?? id;
    title = titleField ?? title;
    url = urlField ?? url;
    thumbnailUrl = thumbnailUrlField ?? thumbnailUrl;
    rebuildWidget();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[photoAlbumIdField] = albumId;
    data[photoIdField] = id;
    data[photoTitleField] = title;
    data[photoUrlField] = url;
    data[photoThumbnailUrlField] = thumbnailUrl;

    return data;
  }

  @override
  get instance => Photo();
}
