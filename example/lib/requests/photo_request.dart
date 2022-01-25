import 'package:example/models/photo_model.dart';
import 'package:mc/mc.dart';

class GetPhotos {
  static Future getPhotos(Photo photo) => McController()
      .get<McRequest>('rq')
      .getObjData("photos", photo, multi: true);
}
