import 'package:mc/mc.dart';

class User extends McModel {
  int id;
  String name;
  String username;
  String email;
  Address address;
  String phone;
  String website;
  Company company;
  String img;
  List multi;

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.address,
      this.phone,
      this.website,
      this.company,
      this.img}) {
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
    website = json['website'] ?? website;
    img = json['image'] ?? img;
    company.fromJson(json['company'] ?? company.toJson());
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['address'] = this.address.toJson();
    data['phone'] = this.phone;
    data['website'] = this.website;
    data['image'] = this.img;
    data['company'] = this.company.toJson();

    return data;
  }

  void setMulti(List d) {
    List r = d.map((e) {
      User m = User();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }
}

class Geo extends McModel {
  String lat;
  String lng;
  List multi;

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

  void setMulti(List d) {
    List r = d.map((e) {
      Geo m = Geo();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }
}

class Address extends McModel {
  String street;
  String suite;
  String city;
  String zipcode;
  Geo geo;
  List multi;

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

  void setMulti(List d) {
    List r = d.map((e) {
      Address m = Address();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }
}

class Company extends McModel {
  String name;
  String catchPhrase;
  String bs;
  List multi;

  Company({
    this.name,
    this.catchPhrase,
    this.bs,
  }) {
    multi = multi ?? [];
  }
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

  void setMulti(List d) {
    List r = d.map((e) {
      Company m = Company();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }
}

//Controller of your main model
//if you need more controller you can copy this and use it

class UserC {
  static final UserC _userC = UserC._internal();
  User user = User();
  factory UserC() {
    return _userC;
  }

  void delUSer(int index) {
    user.multi.removeAt(index);
    user.rebuild();
  }

  //you can add more methods
  UserC._internal();
}

