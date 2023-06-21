import 'dart:collection';

import 'package:rocket_singleton/rocket_singleton.dart';

extension HasKey on HashMap {
  bool hasKey(String key) {
    bool checker = false;
    forEach((k, value) {
      if (key == k) checker = true;
    });
    return checker;
  }
}

extension Save on dynamic {
  T save<T>({
    String? key,
    bool readOnly = false,
  }) {
    return Rocket.add(this, key: key, readOnly: readOnly);
  }
}
