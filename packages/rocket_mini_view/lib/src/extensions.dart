
import 'package:rocket_mini_view/rocket_mini_view.dart';

extension Easy<T> on T {
  RocketValue<T> get mini {
    return RocketValue<T>(this);
  }
}