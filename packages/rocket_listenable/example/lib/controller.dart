import 'package:rocket_listenable/rocket_listenable.dart';

/// A class that represents a counter that can be incremented and decremented.
///
/// This class extends [RocketListenable] to allow other objects to register and unregister listeners,
/// and can notify its listeners when its value changes.
class CounterController extends RocketListenable {
  int _value = 0;

  /// The current value of the counter.
  int get value => _value;

  set value(int newValue) {
    if (_value != newValue) {
      _value = newValue;

      // Notify listeners that the value has changed.
      callListener('valueChanged');
    }
  }

  /// Increments the counter by 1.
  void increment() {
    value++;
  }

  /// Decrements the counter by 1.
  void decrement() {
    value--;
  }
}
