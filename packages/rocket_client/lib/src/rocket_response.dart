import 'package:rocket_model/rocket_model.dart';

class RocketResponse extends RocketModel {
  RocketResponse(this.response, this.kStatusCode);
  dynamic response;
  int kStatusCode;
  void update(dynamic resp, int statusCode) {
    kStatusCode = statusCode;
    response = resp;
  }

  @override
  get apiResponse => response;

  @override
  int get statusCode => kStatusCode;
}
