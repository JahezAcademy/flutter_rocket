import 'package:mc/mc.dart';

class Counter extends McModel {
  int count;
  List multi = [];

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

  void setMulti(List d) {
    List r = d.map((e) {
      Counter m = Counter();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }
}
