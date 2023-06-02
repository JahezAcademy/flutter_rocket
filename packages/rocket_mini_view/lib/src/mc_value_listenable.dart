import 'package:rocket_listenable/rocket_listenable.dart';

import 'constants.dart';

class RocketValue<T> extends RocketListenable {
  RocketValue(this._value);
  T get v => _value!;
  T? _value;

  set v(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    rebuildWidget();
  }

  void rebuildWidget() {
    if (keyHasListeners(rocketMiniRebuild)) callListener(rocketMiniRebuild);
    if (keyHasListeners(rocketMergesRebuild)) callListener(rocketMergesRebuild);
  }

  RocketValue.merge(List<RocketListenable> kMerges) {
    merges = kMerges;
  }
}
