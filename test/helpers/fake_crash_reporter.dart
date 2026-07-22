import 'dart:developer';
import 'package:nuntium/core/errors/crash_reporter.dart';

class FakeCrashReporter implements CrashReporter {
  @override
  Future<void> reportError({
    required dynamic exception,
    required StackTrace? stackTrace,
    dynamic reason,
    bool fatal = false,
  }) async {
    log(exception.toString());
  }
}
