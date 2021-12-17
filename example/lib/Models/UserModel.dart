import 'package:mc/mc.dart';

class User extends McModel<User> {
  List<User> multi;
  int id;
  String name;
  String username;
  String email;
  Address address;
  String phone;
  String website;
  Company company;
  String image;
  final String idStr = "id";
  final String nameStr = "name";
  final String usernameStr = "username";
  final String emailStr = "email";
  final String addressStr = "address";
  final String phoneStr = "phone";
  final String websiteStr = "website";
  final String companyStr = "company";
  final String imageStr = "image";

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.address,
      this.phone,
      this.website,
      this.company,
      this.image}) {
    multi = multi ?? [];
    address ??= Address();
    company ??= Company();
  }
  fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? id;
    name = json['name'] ?? name;
    username = json['username'] ?? username;
    email = json['email'] ?? email;
    address.fromJson(json['address'] ?? address.toJson());
    phone = json['phone'] ?? phone;
    image = json['image'] ?? image;
    website = json['website'] ?? website;
    company.fromJson(json['company'] ?? company.toJson());
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['image'] = this.image;
    data['email'] = this.email;
    data['address'] = this.address.toJson();
    data['phone'] = this.phone;
    data['website'] = this.website;
    data['company'] = this.company.toJson();

    return data;
  }

  void setMulti(List data) {
    List listOfuser = data.map((e) {
      User user = User();
      user.fromJson(e);
      return user;
    }).toList();
    multi = listOfuser;
  }
}

class Geo extends McModel<Geo> {
  List<Geo> multi;
  String lat;
  String lng;

  Geo({
    this.lat,
    this.lng,
  }) {
    multi = multi ?? [];
  }
  fromJson(Map<String, dynamic> json) {
    lat = json['lat'] ?? lat;
    lng = json['lng'] ?? lng;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;

    return data;
  }

  void setMulti(List data) {
    List listOfgeo = data.map((e) {
      Geo geo = Geo();
      geo.fromJson(e);
      return geo;
    }).toList();
    multi = listOfgeo;
  }
}

class Company extends McModel<Company> {
  String name;
  String catchPhrase;
  String bs;

  Company({
    this.name,
    this.catchPhrase,
    this.bs,
  });
  fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? name;
    catchPhrase = json['catchPhrase'] ?? catchPhrase;
    bs = json['bs'] ?? bs;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['catchPhrase'] = this.catchPhrase;
    data['bs'] = this.bs;

    return data;
  }
}

class Address extends McModel<Address> {
  String street;
  String suite;
  String city;
  String zipcode;
  Geo geo;

  Address({
    this.street,
    this.suite,
    this.city,
    this.zipcode,
    this.geo,
  }) {
    geo ??= Geo();
  }
  fromJson(Map<String, dynamic> json) {
    street = json['street'] ?? street;
    suite = json['suite'] ?? suite;
    city = json['city'] ?? city;
    zipcode = json['zipcode'] ?? zipcode;
    geo.fromJson(json['geo'] ?? geo.toJson());
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['suite'] = this.suite;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    data['geo'] = this.geo.toJson();

    return data;
  }
}
