import 'package:example/models/photo_model.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

const String photosEndpoint = "photos";

class GetPhotos {
  static Future getPhotos(Photo photoModel) => RocketController()
      .get<RocketRequest>(mcRequestKey)
      .getObjData(photosEndpoint, photoModel, multi: true);
}
