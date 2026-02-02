abstract class Failure {
  final String message;
  const Failure(this.message);
}

class OfflineFailure extends Failure {
  const OfflineFailure({String message = "No Internet Connection"})
    : super(message);
}

class AuthFailure extends Failure {
  final String? errorCode;
  const AuthFailure(super.message, {this.errorCode});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class UnkonwnFailure extends Failure {
  const UnkonwnFailure(super.message);
}
