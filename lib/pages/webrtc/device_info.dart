import 'dart:io';

// ignore: avoid_classes_with_only_static_members
class DeviceInfo {
  static String get label {
    return '${Platform.localHostname}(${Platform.operatingSystem})';
  }

  static String get userAgent {
    return 'flutter-webrtc/${Platform.operatingSystem}-plugin 0.0.1';
  }
}
