class OfflineException implements Exception {}

class ServerException implements Exception {
  final int? statusCode;
  final String message;

  ServerException(this.message,{this.statusCode});
}

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({required this.message, this.code});
}
