import 'package:mvc_rocket/mvc_rocket.dart';

class Counter extends RocketModel<Counter> {
  int count;

  Counter({
    this.count = 0,
  });
  fromJson(covariant Map<String, dynamic> json) {
    count = json['count'] ?? count;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;

    return data;
  }
}