import 'dart:collection';

import 'package:rocket_singleton/rocket_singleton.dart';

extension HasKey on HashMap {
  bool hasKey(dynamic key) {
    return containsKey(key);
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
