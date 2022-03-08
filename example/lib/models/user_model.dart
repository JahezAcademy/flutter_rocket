import 'package:mc/mvc_rocket.dart';

import 'user_submodel/address_submodel.dart';
import 'user_submodel/company_submodel.dart';

class User extends RocketModel<User> {
  List<User>? multi;
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

  void fromJson(covariant Map<String, dynamic> json) {
    id = json['id'] ?? id;
    name = json['name'] ?? name;
    username = json['username'] ?? username;
    email = json['email'] ?? email;
    address!.fromJson(json['address'] ?? address!.toJson());
    phone = json['phone'] ?? phone;
    image = json['image'] ?? image;

    website = json['website'] ?? website;
    company!.fromJson(json['company'] ?? company!.toJson());
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['address'] = this.address!.toJson();
    data['phone'] = this.phone;
    data['website'] = this.website;
    data['company'] = this.company!.toJson();
    data['image'] = this.image;

    return data;
  }

  void setMulti(List data) {
    List<User> listOfuser = data.map((e) {
      User user = User();
      user.fromJson(e);
      return user;
    }).toList();
    multi = listOfuser;
  }
}
