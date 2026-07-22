import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

class OfflineFailure extends Failure {
  const OfflineFailure({String message = "No Internet Connection"})
    : super(message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  final String? errorCode;
  const AuthFailure(super.message, {this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
  
  @override
  List<Object?> get props =>  [message];
}

class UnkonwnFailure extends Failure {
  const UnkonwnFailure(super.message);
  
  @override
  List<Object?> get props =>  [message];
}
