import 'package:mvc_rocket/mvc_rocket.dart';

import 'geo_submodel.dart';

const String addressStreetField = "street";
const String addressSuiteField = "suite";
const String addressCityField = "city";
const String addressZipcodeField = "zipcode";
const String addressGeoField = "geo";

class Address extends RocketModel<Address> {
  String? street;
  String? suite;
  String? city;
  String? zipcode;
  Geo? geo;

  Address({
    this.street,
    this.suite,
    this.city,
    this.zipcode,
    this.geo,
  }) {
    geo ??= Geo();
  }

  @override
  fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    street = json[addressStreetField] ?? street;
    suite = json[addressSuiteField] ?? suite;
    city = json[addressCityField] ?? city;
    zipcode = json[addressZipcodeField] ?? zipcode;
    geo!.fromJson(json[addressGeoField] ?? geo!.toJson(), isSub: isSub);
    super.fromJson(json, isSub: isSub);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[addressStreetField] = street;
    data[addressSuiteField] = suite;
    data[addressCityField] = city;
    data[addressZipcodeField] = zipcode;
    data[addressGeoField] = geo!.toJson();

    return data;
  }
}
