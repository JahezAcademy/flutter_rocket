import 'package:mvc_rocket/mvc_rocket.dart';

import 'user_submodel/address_submodel.dart';
import 'user_submodel/company_submodel.dart';

class User extends RocketModel<User> {
  int? id;
  String? name;
  String? username;
  String? email;
  Address? address;
  String? phone;
  String? website;
  Company? company;
  String? image;

  String idVar = "id";
  String nameVar = "name";
  String usernameVar = "username";
  String emailVar = "email";
  String addressVar = "address";
  String phoneVar = "phone";
  String websiteVar = "website";
  String companyVar = "company";
  String imageVar = "image";

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
    address ??= Address();
    company ??= Company();
  }

  @override
  void fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    id = json['id'] ?? id;
    name = json['name'] ?? name;
    username = json['username'] ?? username;
    email = json['email'] ?? email;
    address!.fromJson(json['address'] ?? address!.toJson(), isSub: isSub);
    phone = json['phone'] ?? phone;
    image = json['image'] ?? image;
    website = json['website'] ?? website;
    company!.fromJson(json['company'] ?? company!.toJson(), isSub: isSub);
    super.fromJson(json, isSub: isSub);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['address'] = address!.toJson();
    data['phone'] = phone;
    data['website'] = website;
    data['company'] = company!.toJson();
    data['image'] = image;

    return data;
  }

  @override
  get instance => User();
}
