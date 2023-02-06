import 'package:mvc_rocket/mvc_rocket.dart';

class RocketRequestTest extends RocketRequest {
  List<Map<String, dynamic>> dummyData;
  RocketRequestTest(
    this.dummyData,
  ) : super(url: '');
  @override
  Future request<T>(String endpoint,
      {RocketModel<T>? model,
      HttpMethods method = HttpMethods.get,
      Function(dynamic data)? inspect,
      Map<String, dynamic>? data,
      Map<String, dynamic>? params}) async {
    model!.state = RocketState.loading;
    await Future.delayed(const Duration(seconds: 1));
    try {
      model.setMulti(dummyData);
      model.state = RocketState.done;
    } catch (e) {
      model.setException(RocketException(exception: e.toString()));
    }

    return model;
  }
}
