import 'dart:async';

sealed class Result<S> {

  const Result();

  factory Result.success(S value) => Success<S>(value);
  factory Result.failure(Object error, { StackTrace? stackTrace }) => Failure<S>(error, stackTrace: stackTrace);

  FutureOr<R> fold<R>({
    required FutureOr<R> Function(S value) onSuccess, 
    required FutureOr<R> Function(Object error, StackTrace stackTrace) onFailure
  }) async {
    if (this is Success) {
      return await onSuccess((this as Success<S>).value);
    } else if (this is Failure) {
      return await onFailure((this as Failure<S>).error, (this as Failure<S>).stackTrace);
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

  final Object error;
  final StackTrace stackTrace;

  Failure(this.error, { StackTrace? stackTrace })
    : stackTrace = stackTrace ?? StackTrace.current;
}