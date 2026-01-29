import 'package:get_it/get_it.dart';
import 'package:new_nuntium/core/utils/app_logger.dart';

extension SafeResgister on GetIt {
  void safeRegisterLazySingleton<T extends Object>(T Function() factoryFunc) {
    if (!isRegistered<T>()) {
      registerLazySingleton<T>(factoryFunc);
    } else {
      AppLogger.w("'$T' is already registered, skipping Re-regestering...");
    }
  }
}
