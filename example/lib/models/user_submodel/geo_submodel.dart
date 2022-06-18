import 'package:mvc_rocket/mvc_rocket.dart';

const String geoLatField = "lat";
const String geoLngField = "lng";
class Geo extends RocketModel<Geo> {
  String? lat;
  String? lng;

  Geo({
    this.lat,
    this.lng,
  });
  @override
  fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    lat = json[geoLatField] ?? lat;
    lng = json[geoLngField] ?? lng;
    super.fromJson(json, isSub: isSub);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[geoLatField] = lat;
    data[geoLngField] = lng;

    return data;
  }
}
