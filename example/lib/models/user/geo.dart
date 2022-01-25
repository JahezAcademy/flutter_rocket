import 'package:mc/mc.dart';

class Geo extends McModel<Geo> {
  String? lat;
  String? lng;

  String latVar = "lat";
  String lngVar = "lng";
  Geo({
    this.lat,
    this.lng,
  });
  fromJson(covariant Map<String, dynamic> json) {
    lat = json['lat'] ?? lat;
    lng = json['lng'] ?? lng;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lat'] = this.lat;
    data['lng'] = this.lng;

    return data;
  }
}
