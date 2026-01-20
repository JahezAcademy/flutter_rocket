import 'package:rocket_listenable/rocket_listenable.dart';

import 'constants.dart';

class RocketValue<T> extends RocketListenable {
  RocketValue(T initialValue) : _value = initialValue;
  T get v => _value as T;
  dynamic _value;

  set v(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    rebuildWidget();
  }

  void rebuildWidget() {
    callListener(rocketMiniRebuild);
    callListener(rocketMergesRebuild);
  }

  factory RocketValue.merge(List<RocketListenable> kMerges) {
    final rv = RocketValue(null as T);
    rv.merges = kMerges;
    return rv;
  }
}
