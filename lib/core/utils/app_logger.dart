import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

final crashlytics = FirebaseCrashlytics.instance;

enum CrashlyticsErrors{
  serverError,
  authError,
  unexpectedError,
}

class AppLogger {
  static final Logger _logger = Logger(
    // منع الطباعة في وضع الـ Release للحفاظ على الأداء والأمان
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,

      // filter out frames that is not my project
      excludePaths: [
        'package:flutter',
        // 'package:get',
        'package:dart-sdk',
        'dart:ui',
        'dart:async',
        'dart:isolate',
        // 'dart:',
        'package:new_nuntium/core/extensions/get_it_extension.dart',
        'package:new_nuntium/core/utils/app_logger.dart',
      ],
    ),
  );

  static void i(String message) {
    _logger.i(message);
  }

  static void d(String message) {
    _logger.d(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
