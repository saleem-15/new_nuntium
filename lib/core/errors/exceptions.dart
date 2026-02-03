abstract class AppException implements Exception {}

class OfflineException implements AppException {}

class ServerException implements AppException {
  final int? statusCode;
  final String message;

  ServerException(this.message, {this.statusCode});
}

class AuthException implements AppException {
  final String message;
  final String? code;

  AuthException({required this.message, this.code});
}

class UnknownException implements AppException {
  final String message;

  UnknownException(this.message);
}
