import 'rocket_model_base.dart';

extension AllToJson on List<RocketModel> {
  List toJson({List<String>? include, bool onlyValues = false}) {
    return map((e) {
      Map<String, dynamic> json = e.toJson();
      if (include != null) {
        json.removeWhere((key, value) => !include.contains(key));
      }
      return onlyValues ? json.values.toList() : json;
    }).toList();
  }
}
