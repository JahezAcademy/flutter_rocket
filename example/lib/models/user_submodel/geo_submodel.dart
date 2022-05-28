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
  @override
  fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    lat = json['lat'] ?? lat;
    lng = json['lng'] ?? lng;
    super.fromJson(json, isSub: isSub);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lat'] = lat;
    data['lng'] = lng;

    return data;
  }
}
