
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flirtbees/models/remote/notification.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/my_app.dart';
import 'package:flirtbees/pages/authentication/auth_provider.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail_provider.dart';
import 'package:flirtbees/pages/friends/accept_friend_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/app_constant.dart';
import 'package:flirtbees/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart';
import 'package:flirtbees/models/remote/message.dart' as AppMess;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;


}

class NotificationProvider {

  NotificationProvider(this.authProvider, this.accpetFriendProvider, this.callingProvider, this.chatDetailProvider,this.appLoadingProvider);

  final AuthProvider authProvider;
  final AccpetFriendProvider accpetFriendProvider;
  final CallingProvider callingProvider;
  final ChatDetailProvider chatDetailProvider;
  final AppLoadingProvider appLoadingProvider;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Map<String, dynamic> currentMessageData;

  BuildContext lastBuildContext;
  BuildContext currentBuildContext;
  NotificationData notificationData;


  String currentRouteName;
  String clientId;

  void setContext(BuildContext _context) {
    lastBuildContext = currentBuildContext;
    currentBuildContext = _context;
    currentRouteName = ModalRoute.of(currentBuildContext)?.settings?.name;
  }

  void disposeCurrentContext() {
    debugPrint('On dispose notification provider');
    currentBuildContext = lastBuildContext;
    lastBuildContext = null;
    clientId = null;
    currentRouteName = null;
  }

  void setClientId({String id}) {
    if (currentRouteName == AppConstant.chatDetailPageRoute || currentRouteName == AppConstant.searchingPageRoute) {
      clientId = id;
    }
  }

  Future<void> configureNotification() async {

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //SCREEN_OPEN

        handleNotification(status: 'SCREEN_OPEN', message: message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('onLaunch: $message');
        handleNotification(status: 'KILLED', message: message);

      },
      onResume: (Map<String, dynamic> message) async {
        debugPrint('onResume: $message');
        handleNotification(status: 'BACKGROUND', message: message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      debugPrint('Push Messaging token: $token');
      authProvider.fcmToken = token;
    });
  }

  Future<void> configureLocalNotification() async {
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    final InitializationSettings initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            debugPrint('notification payload: ' + payload);
            handleNotificationData(type: payload, message: currentMessageData, buildContext: currentBuildContext);

          }

        });
  }

  void handleNotification({String status, Map<String, dynamic> message}) {
    debugPrint('onMessage: $message');
    try {
      notificationData = NotificationData.fromJson(message);
      Map<String, dynamic> notificationDataPayLoad = (message['aps'] != null) ? Map<String, dynamic>.from(message['aps'] as Map<dynamic, dynamic>) : null;
      if (notificationDataPayLoad == null) {
        //Simulator
        notificationDataPayLoad = (message['notification'] != null) ? Map<String, dynamic>.from(message['notification'] as Map<dynamic, dynamic>) : null;
        notificationData.payload = NotificationPayload.fromJson(notificationDataPayLoad);
      } else {
        //Real device
        final Map<String, dynamic> notificationDataPayLoadAlert = (notificationDataPayLoad['alert'] != null) ? Map<String, dynamic>.from(notificationDataPayLoad['alert'] as Map<dynamic, dynamic>) : null;
        notificationData.payload = NotificationPayload.fromJson(notificationDataPayLoadAlert);
      }

      final User user = User.fromJson(message);

      switch (status) {
        case 'SCREEN_OPEN':
          if (currentBuildContext == null) {
            return;
          }
          if (currentRouteName != null) {
            if (notificationData.type == 'NEW_MESSAGE') {
              if (currentRouteName == AppConstant.chatDetailPageRoute || currentRouteName == AppConstant.searchingPageRoute) {
                if (clientId != null) {
                  if (clientId == notificationData.uid) {
                    return;
                  }
                }
              }
            }
          }
          currentMessageData = message;

          _showNotification(title: notificationData.payload.title, body: notificationData.payload.body, type: notificationData.type);
          break;
        case 'BACKGROUND':
          handleNotificationData(type: notificationData.type, message: message, buildContext: currentBuildContext);
          break;
        case 'KILLED':
          handleNotificationData(type: notificationData.type, message: message, buildContext: currentBuildContext);
          break;
        default: break;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

  }

  void handleNotificationData({String type, Map<String, dynamic> message, BuildContext buildContext}) {
    if (currentBuildContext == null) {
      return;
    }
    final User user = User.fromJson(message);
    switch(type) {
      case 'NEW_MESSAGE':
        final Friend friend = AppHelper.convertUserToFriend(user: user);
        Navigator.pushNamed(buildContext, AppConstant.chatDetailPageRoute);
        getMessages(friend: friend, from: 0, to: 50);
        break;
      case 'NEW_OFFER':
        break;
      case 'NEW_FRIEND_REQUEST':
        accpetFriendProvider.friend = AppHelper.convertUserToFriend(user: user);
        Navigator.pushNamed(buildContext, AppConstant.acceptFriendRoute);
        break;
      case 'FRIEND_ACCEPTED_LEFT':
        break;
      case 'FRIEND_ACCEPTED_RIGHT':
        break;
      default: break;
    }
  }

  Future<void> _showNotification({String type, String title, String body}) async {
    debugPrint('Show notification with: ${type} ${title} ${body}');
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    final IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: type);
  }

  Future<void> getMessages({Friend friend, int from, int to}) async {
    if (callingProvider.messagesList != null) {
      callingProvider.messagesList.clear();
    }
    chatDetailProvider.friend = friend;
    appLoadingProvider.showLoading(currentBuildContext);
    final List<AppMess.Message> messageList = await chatDetailProvider.getListMessage(from: from, to: to);
    await chatDetailProvider.setMessageList(messages: messageList);
    appLoadingProvider.hideLoading();
  }
}
