/// Represents an exception that occurs during data loading or manipulation.
class RocketException {
  /// Creates a new [RocketException].
  ///
  /// [response] The response data when the exception occurred.
  /// [statusCode] The HTTP status code. Defaults to 0 for exceptions.
  /// [exception] The exception message. Defaults to empty string.
  /// [stackTrace] The stack trace. Defaults to empty stack trace.
  RocketException({
    this.response = "Check model",
    this.statusCode = 0,
    this.exception = "",
    this.stackTrace = StackTrace.empty,
  });

  /// The response data when the exception occurred.
  final dynamic response;

  /// The HTTP status code.
  final int statusCode;

  /// The exception message.
  final String exception;

  /// The stack trace.
  final StackTrace stackTrace;

  @override
  String toString() {
    return {
      "response": response,
      "statusCode": statusCode,
      "exception": exception,
      "stackTrace": stackTrace.toString()
    }.toString();
  }
}
