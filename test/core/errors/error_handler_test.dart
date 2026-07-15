import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/core/errors/crash_reporter.dart';
import 'package:nuntium/core/errors/error_handler.dart';
import 'package:nuntium/core/errors/exceptions.dart';
import 'package:nuntium/core/errors/failures.dart';

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

void main() {
  setUpAll(() {
    getIt.registerSingleton<CrashReporter>(FakeCrashReporter());
  });

  test(
    "Errorhandler should return OfflineFailure when getting OfflineException",
    () {
      expect(
        ErrorHandler.handle(OfflineException(), StackTrace.current),
        isA<OfflineFailure>(),
      );
    },
  );
  test(
    "Errorhandler should return ServerFailure when getting ServerException",
    () {
      final exception = ServerException("Fail", statusCode: 500);
      expect(
        ErrorHandler.handle(
          exception,
          StackTrace.current,
        ),
        ServerFailure('Server Error: $exception'),
      );
    },
  );
}
