class RocketException {
  RocketException(
      {this.response = "Check model",
      this.statusCode = 200,
      this.exception = "",
      this.stackTrace = StackTrace.empty});
  final dynamic response;
  final int statusCode;
  final String exception;
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
