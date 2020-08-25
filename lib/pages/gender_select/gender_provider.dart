import 'dart:async';

import 'package:flutter/material.dart';

class GenderProvider with ChangeNotifier {
  GenderProvider() {
    startTimer();
  }

  static const int maxDuration = 5000;
  static const int tick = 100;
  int countDownTime = 0;
  bool get isTimerRunning => countDownTime > 0;
  int firstTime = 0;

  double get timerValue => countDownTime / maxDuration;

  bool get halfProgressing => countDownTime >= maxDuration / 2;
  bool get isCompleted => countDownTime >= maxDuration;

  void resetCountDown() {
    countDownTime = 0;
  }
  
  void startTimer() {
    if (isTimerRunning) {
      debugPrint('Timer is running');
      return;
    }
    Timer.periodic(const Duration(milliseconds: tick), (Timer timer) {
      if (countDownTime == maxDuration) {
        timer.cancel();
        if (firstTime == 1) {
          firstTime = 2;
          notifyListeners();
          return;
        }
        firstTime = 1;
        return;
      }
      countDownTime += tick;
      debugPrint('Count down time : $countDownTime');
      notifyListeners();
    });
  }


}