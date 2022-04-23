import 'package:mvc_rocket/mvc_rocket.dart';

import 'geo_submodel.dart';

class Address extends RocketModel<Address> {
  String? street;
  String? suite;
  String? city;
  String? zipcode;
  Geo? geo;

  String streetVar = "street";
  String suiteVar = "suite";
  String cityVar = "city";
  String zipcodeVar = "zipcode";
  String geoVar = "geo";
  Address({
    this.street,
    this.suite,
    this.city,
    this.zipcode,
    this.geo,
  }) {
    multi = multi ?? [];
    geo ??= Geo();
  }
  fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    street = json['street'] ?? street;
    suite = json['suite'] ?? suite;
    city = json['city'] ?? city;
    zipcode = json['zipcode'] ?? zipcode;
    geo!.fromJson(json['geo'] ?? geo!.toJson(), isSub: isSub);
    return super.fromJson(json, isSub: isSub);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['street'] = this.street;
    data['suite'] = this.suite;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    data['geo'] = this.geo!.toJson();

    return data;
  }
}
