import 'dart:async';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/authentication/auth_provider.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'calling_provider.dart';

class SearchProvider with ChangeNotifier {
  SearchProvider(this.authProvider, this.localStorage, this.callingProvider);

  final AuthProvider authProvider;
  final LocalStorage localStorage;
  final CallingProvider callingProvider;

  bool shouldDisplaySearchResults = false;
  bool isResultExpanding = false;
  bool isCameraPermissionGranted = false;
  bool isMicroPermissionGranted = false;

  static const int maxDuration = 300;
  int countDownTime = maxDuration;
  bool get isTimerRunning => countDownTime < maxDuration;

  void resetCountDown() {
    localStorage.saveGuestUserStatus(isGuestUser: false);
    countDownTime = maxDuration;
  }

  void toggleExpanding() {
    isResultExpanding = !isResultExpanding;
    notifyListeners();
  }

  Future<void> requestGuestToken({bool isLoggedIn = false, Function(bool isSuccess, String messages, User user) callback}) async {
    if (!isLoggedIn) {
      if (isTimerRunning) {
        debugPrint('Timer is running');
        return;
      }
      final bool isHaveGuestToken = await localStorage.isGuestUser();
      if (!isHaveGuestToken) {
        await authProvider.guestLogin(callback: (bool isSuccess, String msg, User user) {
          if (isSuccess) {
            Fluttertoast.showToast(msg: 'You have logged success as a guest user. This session will expired and auto logout after 5 minutes. ');
            localStorage.saveGuestUserStatus(isGuestUser: true);
            callback(isSuccess, msg, user);
          }
        });
      }
      return;
    }
    shouldDisplaySearchResults = true;
    notifyListeners();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if (countDownTime == 0) {
        await handleGuestUserTokenExpired();
        timer.cancel();
        resetCountDown();
        return;
      }
      countDownTime -= 1;
      debugPrint('Count down time : $countDownTime');
      notifyListeners();
    });
  }

  Future<void> handleGuestUserTokenExpired() async {
    await authProvider.handleLogout();
    callingProvider.disconnect();
    callingProvider.clearData();
  }

  Future<bool> isAllPermissionsGranted() async {
    isCameraPermissionGranted = await Permission.camera.isGranted;
    isMicroPermissionGranted = await Permission.microphone.isGranted;
    if (isCameraPermissionGranted && isMicroPermissionGranted) {
      return true;
    }
    return false;
  }

  Future<bool> requestCameraPermission() async {
    if (isCameraPermissionGranted) {
      return isMicroPermissionGranted;
    }
    // ignore: always_specify_types
    final Map<Permission, PermissionStatus> statuses = await [Permission.camera].request();
    if (statuses[Permission.camera].isGranted) {
      isCameraPermissionGranted = true;
    }
    if (!isMicroPermissionGranted) {
      notifyListeners();
    }
    return isMicroPermissionGranted;
  }

  Future<bool> requestMicrophonePermission() async {
    if (isMicroPermissionGranted) {
      return isCameraPermissionGranted;
    }
    // ignore: always_specify_types
    final Map<Permission, PermissionStatus> statuses = await [Permission.microphone].request();
    if (statuses[Permission.microphone].isGranted) {
      isMicroPermissionGranted = true;
    }
    if (!isCameraPermissionGranted) {
      notifyListeners();
    }
    return isCameraPermissionGranted;
  }

}