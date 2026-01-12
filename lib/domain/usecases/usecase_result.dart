sealed class UseCaseResult<T> {
  const UseCaseResult();

  factory UseCaseResult.success(T value) = UseCaseResultSuccess<T>;

  factory UseCaseResult.failure(Exception exception) = UseCaseResultFailure<T>;

  R when<R>({
    required R Function(T value) success,
    required R Function(Exception exception) failure,
  }) {
    return switch (this) {
      UseCaseResultSuccess(:final value) => success(value),
      UseCaseResultFailure(:final exception) => failure(exception),
    };
  }

  R? whenOrNull<R>({
    R Function(T value)? success,
    R Function(Exception exception)? failure,
  }) {
    return switch (this) {
      UseCaseResultSuccess(:final value) => success?.call(value),
      UseCaseResultFailure(:final exception) => failure?.call(exception),
    };
  }

  bool get isSuccess => this is UseCaseResultSuccess<T>;
  bool get isFailure => this is UseCaseResultFailure<T>;

  T? get valueOrNull => switch (this) {
    UseCaseResultSuccess(:final value) => value,
    UseCaseResultFailure() => null,
  };

  Exception? get exceptionOrNull => switch (this) {
    UseCaseResultSuccess() => null,
    UseCaseResultFailure(:final exception) => exception,
  };
}

final class UseCaseResultSuccess<T> extends UseCaseResult<T> {
  final T value;

  const UseCaseResultSuccess(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UseCaseResultSuccess<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'UseCaseResultSuccess($value)';
}

final class UseCaseResultFailure<T> extends UseCaseResult<T> {
  final Exception exception;

  const UseCaseResultFailure(this.exception);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UseCaseResultFailure<T> &&
          runtimeType == other.runtimeType &&
          exception == other.exception;

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() => 'UseCaseResultFailure($exception)';
}
