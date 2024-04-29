sealed class Result<S> {

  const Result();

  factory Result.success(S value) => Success<S>(value);
  factory Result.failure(Exception exception, { StackTrace? stackTrace }) => Failure<S>(exception, stackTrace: stackTrace);

  R fold<R>({
    required R Function(S value) onSuccess, 
    required R Function(Exception exception, StackTrace stackTrace) onFailure
  }) {
    if (this is Success) {
      return onSuccess((this as Success<S>).value);
    } else if (this is Failure) {
      return onFailure((this as Failure<S>).exception, (this as Failure<S>).stackTrace);
    } else {
      throw Exception('Unexpected Result type');
    }
  }
}

final class Success<S> extends Result<S> {
  final S value;

  const Success(this.value);
}

final class Failure<S> extends Result<S> {

  final Exception exception;
  final StackTrace stackTrace;

  Failure(this.exception, { StackTrace? stackTrace })
    : stackTrace = stackTrace ?? StackTrace.current;
}