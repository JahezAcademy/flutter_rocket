import 'package:mc/src/mc_llistenable.dart';

class McValue<T> extends McListenable{
  McValue(this._value);
  T get value => _value;
  T _value;
  final String _initial = "valueChanged";

  set value(T newValue) {
    if (_value == newValue)
      return;
    _value = newValue;
    notifyListener(_initial);
  }
}

