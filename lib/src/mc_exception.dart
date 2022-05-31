class RocketException {
  RocketException(
      {this.response = "",
      this.statusCode = 0,
      this.exception = "",
      this.stackTrace = StackTrace.empty});
  final String response;
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
