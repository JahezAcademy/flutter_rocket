import 'package:rocket_model/rocket_model.dart';

class ExampleModel extends RocketModel<ExampleModel> {
  int? id;
  String? name;

  final ExampleApi _api = ExampleApi();

  Future<void> loadData() async {
    state = RocketState.loading;
    try {
      final data = await _api.getData();
      setMulti(data);
    } catch (e) {
      setException(RocketException(exception: 'Failed to load data: $e'));
    }
  }

  @override
  void fromJson(Map<String, dynamic> json, {bool isSub = false}) {
    if (isSub) {
      id = json['id'];
      name = json['name'];
    } else {
      super.fromJson(json, isSub: isSub);
    }
    super.fromJson(json, isSub: isSub);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'data': all?.map((data) => data.toJson()).toList()};
  }

  @override
  get instance => ExampleModel();
}

class ExampleApi {
  Future<List<Map<String, dynamic>>> getData() async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 2));

    return [
      {'id': 1, 'name': 'First data'},
      {'id': 2, 'name': 'Second data'},
      {'id': 3, 'name': 'Third data'},
    ];
  }
}
