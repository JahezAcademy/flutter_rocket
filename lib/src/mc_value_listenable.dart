import 'dart:ui';
import 'package:mc/src/mc_llistenable.dart';

import 'mc_constants.dart';

class McValue<T> extends McListenable {
  McValue(this._value);
  T get v => _value!;
  T? _value;

  set v(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    rebuildWidget();
  }

  void rebuildWidget() {
    if (keyHasListeners(miniRebuild)) callListener(miniRebuild);
    if (keyHasListeners(mergesRebuild)) callListener(mergesRebuild);
  }

  McValue.merge(List<McListenable> _merges) {
    merges = _merges;
  }

  /// for add listener for rebuild widget you can use McValue.miniRebuild or McValue.mergesRebuild as key
  @override
  void registerListener(String key, VoidCallback listener) {
    super.registerListener(key, listener);
  }
}

extension Easy<T> on T {
  McValue<T> get mini {
    return McValue<T>(this);
  }
}
