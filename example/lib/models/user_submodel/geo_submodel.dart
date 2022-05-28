import 'package:mvc_rocket/mvc_rocket.dart';

class Geo extends RocketModel<Geo> {
  String? lat;
  String? lng;

  String latVar = "lat";
  String lngVar = "lng";
  Geo({
    this.lat,
    this.lng,
  });
  fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    lat = json['lat'] ?? lat;
    lng = json['lng'] ?? lng;
    super.fromJson(json, isSub: isSub);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lat'] = this.lat;
    data['lng'] = this.lng;

    return data;
  }
}
