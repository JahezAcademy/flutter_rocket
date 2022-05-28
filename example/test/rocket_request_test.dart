import 'package:mvc_rocket/mvc_rocket.dart';

import 'dummyData.dart';

class RocketRequestTest {
  final String url;
  RocketRequestTest(this.url);
  Future getObjData<T>(
    String endpoint,
    RocketModel<T> model, {
    Map<String, dynamic>? params,
    bool multi = false,
    dynamic Function(dynamic)? inspect,
  }) async {
    model.state = RocketState.loading;
    await Future.delayed(Duration(seconds: 1));
    try {
      model.setMulti(postData);
      model.state = RocketState.done;
    } catch (e) {
      model.setException(RocketException(exception: e.toString()));
    }

    return model;
  }
}
