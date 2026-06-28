class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException(this.message, {this.code});
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}
