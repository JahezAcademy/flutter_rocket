import 'package:mc/mc.dart';

class Company extends McModel<Company> {
  List<Company>? multi;
  String? name;
  String? catchPhrase;
  String? bs;

  String nameVar = "name";
  String catchPhraseVar = "catchPhrase";
  String bsVar = "bs";
  Company({
    this.name,
    this.catchPhrase,
    this.bs,
  }) {
    multi = multi ?? [];
  }
  fromJson(covariant Map<String, dynamic> json) {
    name = json['name'] ?? name;
    catchPhrase = json['catchPhrase'] ?? catchPhrase;
    bs = json['bs'] ?? bs;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['catchPhrase'] = this.catchPhrase;
    data['bs'] = this.bs;

    return data;
  }

  void setMulti(List data) {

    List<Company> listOfcompany = data.map((e) {
      Company company = Company();
      company.fromJson(e);
      return company;
    }).toList();
    multi = listOfcompany;
  }
}
