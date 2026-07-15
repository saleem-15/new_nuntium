import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Abstract contract for reporting crashes and unhandled errors.
/// Core logic depends on this interface rather than concrete third-party SDKs
/// (e.g. FirebaseCrashlytics), enabling easy testing and service replacement.
abstract class CrashReporter {
  Future<void> reportError({
    required dynamic exception,
    required StackTrace? stackTrace,
    dynamic reason,
    bool fatal = false,
  });
}

/// Firebase Crashlytics implementation of [CrashReporter].
class FirebaseCrashReporter implements CrashReporter {
  final FirebaseCrashlytics _crashlytics;

  FirebaseCrashReporter({FirebaseCrashlytics? crashlytics})
      : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  @override
  Future<void> reportError({
    required dynamic exception,
    required StackTrace? stackTrace,
    dynamic reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }
}
