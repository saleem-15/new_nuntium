import 'package:new_nuntium/core/errors/exceptions.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import 'package:new_nuntium/core/utils/app_logger.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Handle App Exceptions and convert them into Failures with user-friendly messages.
  static Failure handle(dynamic error, StackTrace stackTrace) {
    return switch (error) {
      OfflineException _ => OfflineFailure(),

      AuthException() => _handleAuthError(error, stackTrace),

      ServerException _ => _handleServerError(error, stackTrace),

      _ => _handleUnknownError(error, stackTrace),

      // يطابق النوع + قيمة الكود
      // FirebaseAuthException(code: 'user-not-found') => ...
    };
  }

  static AuthFailure _handleAuthError(
    AuthException error,
    StackTrace stackTrace,
  ) {
    crashlytics.recordError(
      error,
      stackTrace,
      reason: '${CrashlyticsErrors.authError}: ${error.code}',
    );

    return AuthFailure(error.message, errorCode: error.code);
  }

  static ServerFailure _handleServerError(
    ServerException e,
    StackTrace stackTrace,
  ) {
    crashlytics.recordError(
      e,
      stackTrace,
      reason: "${CrashlyticsErrors.serverError}: ${e.message}",
    );
    return ServerFailure('Server Error: $e');
  }

  static Failure _handleUnknownError(dynamic e, StackTrace stackTrace) {
    crashlytics.recordError(
      e,
      stackTrace,
      reason: CrashlyticsErrors.unexpectedError,
    );

    return UnkonwnFailure("Unknown error occurred $e");
  }
}













