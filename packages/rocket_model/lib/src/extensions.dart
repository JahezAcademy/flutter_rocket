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

extension LocalCache on RocketModel {
  Future<void> saveToCache(String key) async {
    final jsonString = toJson().toString();
    await saveToLocalStorage(key, jsonString);
  }

  Future<void> loadFromCache(String key) async {
    final jsonString = await loadFromLocalStorage(key);
    if (jsonString != null) {
      fromJson(jsonDecode(jsonString));
    }
  }
}
