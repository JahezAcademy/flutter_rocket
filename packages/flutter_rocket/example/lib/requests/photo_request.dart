import 'package:example/models/photo_model.dart';
import 'package:flutter_rocket/rocket.dart';

const String photosEndpoint = "photos";

class GetPhotos {
  static Future getPhotos(Photo photoModel) =>
      Rocket.get<RocketClient>().request(photosEndpoint, model: photoModel);
}
