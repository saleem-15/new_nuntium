import 'package:flutter_test/flutter_test.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/core/errors/crash_reporter.dart';
import 'package:nuntium/core/errors/error_handler.dart';
import 'package:nuntium/core/errors/exceptions.dart';
import 'package:nuntium/core/errors/failures.dart';

import '../../helpers/fake_crash_reporter.dart';

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
