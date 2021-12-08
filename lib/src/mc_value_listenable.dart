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
    notifyListener(_valueChanged);
    notifyListener(_mergesChanged);
  }

  McValue.merge(List<McListenable> _merges) {
    merges = _merges;
  }
}
