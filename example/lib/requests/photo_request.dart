import 'package:example/models/photo_model.dart';
import 'package:mc/mc.dart';

const String photosEndpoint = "photos";

class GetPhotos {
  static Future getPhotos(Photo photoModel) => McController()
      .get<McRequest>(mcRequestKey)
      .getObjData(photosEndpoint, photoModel, multi: true);
}
