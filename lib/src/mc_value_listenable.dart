import 'dart:ui';
import 'mc_llistenable.dart';
import 'mc_constants.dart';

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

  /// for add listener for rebuild widget you can use miniRebuild or mergesRebuild as key
  @override
  void registerListener(String key, VoidCallback listener) {
    super.registerListener(key, listener);
  }
}

extension Easy<T> on T {
  RocketValue<T> get mini {
    return RocketValue<T>(this);
  }
}
