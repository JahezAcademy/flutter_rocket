class RocketException {
  RocketException(
      {this.response = "Check model",
      this.statusCode = 200,
      this.exception = "Nothing",
      this.stackTrace = StackTrace.empty,
      this.cacheKey = ""});
  final dynamic response;
  final int statusCode;
  final String exception;
  final StackTrace stackTrace;
  final String cacheKey;

  @override
  String toString() {
    return {
      "response": response,
      "statusCode": statusCode,
      "exception": exception,
      "stackTrace": stackTrace.toString(),
      "cacheKey": cacheKey
    }.toString();
  }
}
