import 'package:mvc_rocket/mvc_rocket.dart';

class Company extends RocketModel<Company> {
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

  @override
  fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    name = json['name'] ?? name;
    catchPhrase = json['catchPhrase'] ?? catchPhrase;
    bs = json['bs'] ?? bs;
    super.fromJson(json, isSub: isSub);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['catchPhrase'] = catchPhrase;
    data['bs'] = bs;

    return data;
  }
}
