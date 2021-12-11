import 'dart:ui';
import 'package:mc/src/mc_llistenable.dart';

class McValue<T> extends McListenable {
  McValue(this._value);
  T get v => _value!;
  T? _value;
  final String _valueChanged = "valueChanged";
  final String _mergesChanged = "mergesChanged";

  set v(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    callListener(_valueChanged);
    callListener(_mergesChanged);
  }

  McValue.merge(List<McListenable> _merges) {
    merges = _merges;
  }

  /// for add listener for rebuild widget you can use valueChanged or mergesChanged as key
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
