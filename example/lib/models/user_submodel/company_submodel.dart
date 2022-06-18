import 'package:mvc_rocket/mvc_rocket.dart';

const String companyNameField = "name";
const  String companyCatchPhraseField = "catchPhrase";
const String companyBsField = "bs";

class Company extends RocketModel<Company> {
  String? name;
  String? catchPhrase;
  String? bs;

  Company({
    this.name,
    this.catchPhrase,
    this.bs,
  }) {
    multi = multi ?? [];
  }

  @override
  fromJson(covariant Map<String, dynamic> json, {bool isSub = false}) {
    name = json[companyNameField] ?? name;
    catchPhrase = json[companyCatchPhraseField] ?? catchPhrase;
    bs = json[companyBsField] ?? bs;
    super.fromJson(json, isSub: isSub);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[companyNameField] = name;
    data[companyCatchPhraseField] = catchPhrase;
    data[companyBsField] = bs;

    return data;
  }
}
