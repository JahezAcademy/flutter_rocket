import 'dart:async';
import 'dart:math' as math;
import 'package:http/http.dart';

class RetryOptions {
  const RetryOptions({this.retries, this.retryWhen, this.onRetry, this.delay});
  final int? retries;
  final FutureOr<bool> Function(BaseResponse)? retryWhen;
  final FutureOr<void> Function(BaseRequest, BaseResponse?, int)? onRetry;
  final Duration Function(int)? delay;
  static bool defaultWhen(BaseResponse response) => response.statusCode == 503;
  static int get defaultRetries => 3;
  static Duration defaultDelay(int retryCount) =>
      const Duration(milliseconds: 500) * math.pow(1.5, retryCount);
}
