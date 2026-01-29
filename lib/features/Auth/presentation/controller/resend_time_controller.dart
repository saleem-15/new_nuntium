import 'dart:async';

import 'package:get/get.dart';
import 'package:new_nuntium/core/constants/constanst.dart';

class ResendTimerController extends GetxController {
  RxInt remainingSeconds = Constants.resendEmailTimeInSeconds.obs;
  RxBool isTimerRunning = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    remainingSeconds.value = 30;
    isTimerRunning.value = true;

    // Close any previuos timer, to prevent interference
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        // انتهى الوقت
        isTimerRunning.value = false;
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  // دالة لإعادة الإرسال وإعادة تشغيل المؤقت
  void resend(Function(String) onResendCallback, String email) {
    onResendCallback(email);
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
