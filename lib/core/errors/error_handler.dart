import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/core/errors/crash_reporter.dart';
import 'package:nuntium/core/errors/exceptions.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/core/utils/app_logger.dart';

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
    _safeReportError(
      exception: error,
      stackTrace: stackTrace,
      reason: '${CrashlyticsErrors.authError}: ${error.code}',
    );

    return AuthFailure(error.message, errorCode: error.code);
  }

  static ServerFailure _handleServerError(
    ServerException e,
    StackTrace stackTrace,
  ) {
    _safeReportError(
      exception: e,
      stackTrace: stackTrace,
      reason: CrashlyticsErrors.serverError,
    );
    return ServerFailure('Server Error: $e');
  }

  static Failure _handleUnknownError(dynamic e, StackTrace stackTrace) {
    _safeReportError(
      exception: e,
      stackTrace: stackTrace,
      reason: CrashlyticsErrors.unexpectedError,
    );

    return UnkonwnFailure("Unknown error occurred $e");
  }

  static void _safeReportError({
    required dynamic exception,
    required StackTrace stackTrace,
    required dynamic reason,
  }) {
    try {
      getIt<CrashReporter>()
          .reportError(
            exception: exception,
            stackTrace: stackTrace,
            reason: reason,
          )
          .catchError((_) {});
    } catch (_) {}
  }
}













