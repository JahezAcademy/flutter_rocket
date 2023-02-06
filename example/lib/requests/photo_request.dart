import 'package:example/models/photo_model.dart';

import 'request.dart';

const String photosEndpoint = "photos";

class GetPhotos {
  static Future getPhotos(Photo photoModel) =>
      baseRequest.request(photosEndpoint, model: photoModel);
}
