import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  const AppException();
}

class OfflineException extends AppException {
  const OfflineException();

  @override
  List<Object?> get props => [];
}

class ServerException extends AppException {
  final int? statusCode;
  final String message;

  const ServerException(this.message, {this.statusCode});

  @override
  List<Object?> get props => [statusCode, message];
}

class AuthException extends AppException {
  final String message;
  final String? code;

  const AuthException({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class UnknownException extends AppException {
  final String message;

  const UnknownException(this.message);

  @override
  List<Object?> get props => [message];
}
