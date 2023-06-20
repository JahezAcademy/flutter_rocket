import 'package:rocket_model/rocket_model.dart';

/// A model class for testing purposes.
class TestModel extends RocketModel<TestModel> {
  int? id;
  String? name;
  TestModel({this.id, this.name});

  @override
  void fromJson(Map<String, dynamic> json, {bool isSub = false}) {
    super.fromJson(json, isSub: isSub);
    id = json['id'] as int?;
    name = json['name'] as String?;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': instance.id,
        'name': instance.name,
      };
  @override
  TestModel get instance => TestModel();
}
