class ErrorDetails {

  final Object error;
  final StackTrace stackTrace;

  ErrorDetails({
    required this.error,
    StackTrace? stackTrace
  })  : stackTrace = stackTrace ?? StackTrace.current;
}