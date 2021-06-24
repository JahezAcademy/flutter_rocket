import 'package:mc/mc.dart';

class Counter extends McModel<Counter> {
  int count;

  Counter({
    this.count = 0,
  });
  fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? count;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;

    return data;
  }
}
