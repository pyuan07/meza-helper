/// Result type for operations that can succeed or fail
///
/// Usage:
/// ```dart
/// Future<Result<User>> loadUser() async {
///   try {
///     final user = await api.getUser();
///     return Success(user);
///   } catch (e) {
///     return Failure('Failed to load user', e);
///   }
/// }
///
/// final result = await loadUser();
/// result.when(
///   success: (user) => print('Loaded: ${user.name}'),
///   failure: (message, error) => print('Error: $message'),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Execute callback based on result type
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failure(message: final msg, error: final err) => failure(msg, err),
    };
  }

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get data if success, null otherwise
  T? get dataOrNull => switch (this) {
        Success(data: final data) => data,
        Failure() => null,
      };

  /// Get error message if failure, null otherwise
  String? get errorOrNull => switch (this) {
        Success() => null,
        Failure(message: final msg) => msg,
      };
}

/// Successful result with data
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  String toString() => 'Success($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Failed result with error message
class Failure<T> extends Result<T> {
  final String message;
  final Object? error;

  const Failure(this.message, [this.error]);

  @override
  String toString() => 'Failure($message${error != null ? ", $error" : ""})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          error == other.error;

  @override
  int get hashCode => message.hashCode ^ error.hashCode;
}
