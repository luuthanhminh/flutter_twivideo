import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/services/remote/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppHelper {
  static void showPopup(Widget child, BuildContext context,
      {Function onAction}) {
    showDialog<dynamic>(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: child,
          );
        });
  }

  static String getImageUrl({String imageName}) {
    if (imageName != null) {
      if (imageName.contains('http') || imageName.contains('https')) {
        return imageName;
      } else {
        return '${Api.apiBaseUrl}/api/users/avatar/$imageName';
      }
    }
    return null;
  }

  static Friend convertUserToFriend({User user}) {
    return Friend(name: user.name, avatar: user.avatar, uid: user.uid);
  }

  static Friend convertHistoryFriendToFriend({Friend historyFriend}) {
    return Friend(name: historyFriend.user.name, avatar: historyFriend.user.avatar, uid: historyFriend.user.uid);
  }

  static Future<String> getDeviceUUID() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  static String getDateTimeStringFormatHHmm(String dateString) {
    if (dateString == '' || dateString == null) return '';
    else return DateFormat(DateFormat.HOUR24_MINUTE).format(DateTime.parse(dateString).toLocal());
  }

  static String getDateTimeStringFormatWeekDay(String dateString) {
    if (dateString == '' || dateString == null) return '';
    return DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY).format(DateTime.parse(dateString).toLocal());
  }
}
