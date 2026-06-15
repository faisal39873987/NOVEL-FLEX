class AppException implements Exception {
  final String message;
  final Object? cause;

  const AppException(this.message, {this.cause});

  @override
  String toString() => message;
}

class AppAuthException extends AppException {
  const AppAuthException(String message, {Object? cause})
      : super(message, cause: cause);
}

class AppSessionException extends AppException {
  const AppSessionException(String message, {Object? cause})
      : super(message, cause: cause);
}

class AppDatabaseException extends AppException {
  const AppDatabaseException(String message, {Object? cause})
      : super(message, cause: cause);
}

class AppStorageException extends AppException {
  const AppStorageException(String message, {Object? cause})
      : super(message, cause: cause);
}
