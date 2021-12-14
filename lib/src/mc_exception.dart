class McException {
  McException({this.response="", this.statusCode=0,this.exception="",this.stackTrace=StackTrace.empty});
  final String response;
  final int statusCode;
  final String exception;
  final StackTrace stackTrace;
}
