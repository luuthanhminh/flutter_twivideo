import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/base_response.dart';
import 'package:flirtbees/models/remote/message.dart';
import 'package:flirtbees/models/remote/response/friends/boolean_response.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/models/remote/response/friends/request_friend_response.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail_provider.dart';
import 'package:flirtbees/pages/search/calling_page.dart';
import 'package:flirtbees/pages/search/calling_popup.dart';
import 'package:flirtbees/pages/webrtc/signaling.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/services/remote/api.dart';
import 'package:flirtbees/services/remote/friend_api.dart';
import 'package:flirtbees/services/remote/user_api.dart';
import 'package:flirtbees/utils/app_config.dart';
import 'package:flirtbees/utils/socket_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CallingProvider with ChangeNotifier {
  CallingProvider(this.localStorage, this.userApi, this.friendApi, this.chatDetailProvider, this.socketHelper);

  final LocalStorage localStorage;
  final UserApi userApi;
  final FriendApi friendApi;
  final ChatDetailProvider chatDetailProvider;
  final SocketHelper socketHelper;

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  String clientId = '';
  String selfId = '';

  Signaling signaling;
  bool isReceivedAnswer = false;
  bool isComingCall = false;
  bool _isConnecting = false;
  bool _isInitialized = false;
  String oppositeUserId;
  bool shouldCloseConnection = false;

  bool isRequestedFriend = false;

  bool isInitialized = false;

  User currentClient;
  User currentCaller;
  Friend currentFriend;
  List<User> clientList;

  Function() showCallingPopup;
  Function() closeCallingPopup;

  String currentMessage;
  List<CallMessageItem> messages = <CallMessageItem>[];
  bool isShownGiftView = false;
  List<MessageGift> messageGifts = const <MessageGift>[
    MessageGift(giftName: 'flower', minutes: 5),
    MessageGift(giftName: 'catGift', minutes: 10),
    MessageGift(giftName: 'diamond', minutes: 15),
    MessageGift(giftName: 'tsar', minutes: 20),
    MessageGift(giftName: 'strawberry', minutes: 25)];

  static const int maxDuration = 30;
  int countDownTime = maxDuration;
  Timer currentTimer;

  List<Message> messagesList = <Message>[];

  void updateClientIp(String newClientId) {
    if(clientId != newClientId) {
      clientId = newClientId;
      notifyListeners();
    }
  }

  Future<void> initializeRenderer() async {
    if (!_isInitialized) {
      await localRenderer.initialize();
      await remoteRenderer.initialize();
      _isInitialized = true;
    }
  }

  Future<User> getRandom({Function onAuthorizationDioError}) async {
    try {
      final Response<dynamic> result =
      await userApi.getRandom().timeout(const Duration(seconds: 30));
      debugPrint('Find friend with ${result.data as Map<String, dynamic>}');
      final Friend friend = Friend.fromJson(result.data['data'] as Map<String, dynamic>);
      currentFriend = friend;
      final User user = friend.user;

      if (user != null) {
        log('Find user with uid: ${user.uid}');

        if(currentClient != user) {
          currentClient = user;
          notifyListeners();
        }
        return currentClient;
      } else {
        Fluttertoast.showToast(msg: 'No one was found!');
        return null;
      }
    } on AuthorizationDioError{
      onAuthorizationDioError();
    }catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: 'No one was found!');
      }
      return null;
    }
  }


  Future<void> getUserInfo() async {
    try {
      final Response<dynamic> result =
          await userApi.getUserInfo().timeout(const Duration(seconds: 30));
      final UserResponse userResponse =
          UserResponse(result.data as Map<String, dynamic>);
      selfId = userResponse.data.uid;
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<bool> requestFriend({String friendId}) async {
    try {
      final Response<dynamic> result = await friendApi.requestFriend(friendId: friendId).timeout(const Duration(seconds: 30));
      final FriendRequestResponse friendRequestResponse = FriendRequestResponse(result.data as Map<String, dynamic>);
      if (friendRequestResponse.data.left != null && friendRequestResponse.data.right != null) {
        if(!isRequestedFriend) {
          isRequestedFriend = true;
          notifyListeners();
        }
        return isRequestedFriend;
      }
      return false;
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
      return false;
    }
  }

  Future<bool> cancelRequestFriend({String friendId}) async {
    try {
      final Response<dynamic> result = await friendApi.cancelRequestFriend(friendId: friendId).timeout(const Duration(seconds: 30));
      final BooleanResponse booleanResponse = BooleanResponse(result.data as Map<String, dynamic>);
      if (booleanResponse.isSuccessed) {
        if(isRequestedFriend) {
          isRequestedFriend = false;
          notifyListeners();
        }
      }
      return booleanResponse.isSuccessed;
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
      return false;
    }
  }

  void updateFriendStatus(Friend friend) {
    if(currentFriend != friend) {
      currentFriend = friend;
      notifyListeners();
    }
  }

  void setShownGiftView() {
    if(isShownGiftView != isShownGiftView) {
      isShownGiftView = !isShownGiftView;
      notifyListeners();
    }
  }

  void clearData() {
    isRequestedFriend = false;
    shouldCloseConnection = true;
    _isInitialized = false;
    isShownGiftView = false;
    currentMessage = null;
    isComingCall = false;
    currentCaller = null;
    isReceivedAnswer = false;
    messages.clear();
    if (clientList != null) {
      clientList.clear();
    }
    if (messagesList != null) {
      messagesList.clear();
    }
    currentClient = null;
    if(currentTimer != null) {
      currentTimer.cancel();
    };
    notifyListeners();
  }

  void setClient({User client}) {
    if(currentClient != client) {
      currentClient = client;
      notifyListeners();
    }
  }

  Future<void> getNextUser() async {
    if (signaling != null) {
      signaling.bye();
    }
    clearData();
    getRandom();
  }



  void inviteToCalling({String peerId, BuildContext buildContext}) {
    debugPrint('Invite to calling function');
    if (signaling != null) {
      isReceivedAnswer = false;
      startTimerCheckTimeout();
      signaling.invite(peerId, 'video', false);
    }
  }

  void startTimerCheckTimeout() {
    currentTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if (countDownTime <= 0) {
        timer.cancel();
        resetCountDown();
        checkStatusReceivedAnswer();
        notifyListeners();
        return;
      }
      countDownTime -= 1;
      debugPrint('Count down time : $countDownTime');
    });
  }

  void resetCountDown() {
    countDownTime = maxDuration;
  }

  void checkStatusReceivedAnswer() {
    if (state != SignalingState.CallStateConnected) {
      Fluttertoast.showToast(msg: 'Do not receive response from your friend!');
      closeSignal();
    }
  }

  // If user is null => pop
  // else if state = CallStateRequest => show loading;
  // else if state = CallStateNew => show rtcview;
  // else => show user
  SignalingState state;

  Future<void> connect(BuildContext context) async {
    debugPrint('Go connect in calling provider');
    if (signaling == null) {
      signaling = Signaling(
        Config.instance.env.socketHost,
        Config.instance.env.socketPort,
        localStorage: localStorage,
      );

      signaling.onStateChange = (SignalingState state) {
        print('onStateChange $state');
        this.state = state;
        switch (state) {
          case SignalingState.CallStateNew:
            break;
          case SignalingState.CallStateBye:

          case SignalingState.ConnectionClosed:
            try {
//              if (closeCallingPopup != null) {
//                debugPrint('closeCallingPopup SignalingState.ConnectionClosed');
//                closeCallingPopup();
//              }
              localRenderer.srcObject = null;
              remoteRenderer.srcObject = null;
              debugPrint('localRenderer $localRenderer');
            } catch (e) {
              debugPrint(e.toString());
            }
            break;
          case SignalingState.CallStateInvite:
            break;
          case SignalingState.CallStateConnected:
            debugPrint('On calling connected');
            break;
          case SignalingState.CallStateRinging:
          case SignalingState.ConnectionError:
          case SignalingState.ConnectionOpen:
            break;
          case SignalingState.CallStateRequest:
            break;
        }
        notifyListeners();
      };

      signaling.onReceivedCalling = (Map<String, dynamic> user) {
        currentFriend = Friend.fromJson(user);
        currentCaller = Friend.fromJson(user).user;
        print('onReceivedCalling data: ${user}');
        if(showCallingPopup != null) {
          showCallingPopup();
        }
      };

      signaling.onReceivedMessageCallback = (MessageResponse messageResponse) {
        if (state == SignalingState.CallStateConnected) {
          //Chat in calling
          messages.insert(0, CallMessageItem(id: messageResponse.message.id, message: messageResponse.message.bodyMessage.value, isReceive: true));
          notifyListeners();
        } else {
          //Chat in Chat Room
          final Message message = messageResponse.message;
          message.messageType = AppMessageType.receive;

          //Check current message is message from new day
          final DateTime date1 = DateTime.parse(messageResponse.message.createdAt).toLocal();
          final DateTime date2 = DateTime.parse(chatDetailProvider.messagesList.first.createdAt).toLocal();
          if (date1.day != date2.day) {
            message.isLastMessageInDay = true;
          }

          chatDetailProvider.addMessageToList(message: message);
        }
      };

      // ignore: unnecessary_parenthesis
      signaling.onEventUpdate = ((dynamic event) {
        final String clientId = event['clientId'] as String;
        updateClientIp(clientId);
      });

      // ignore: unnecessary_parenthesis
      signaling.onPeersUpdate = ((dynamic event) {
        selfId = selfId;
      });

      // ignore: unnecessary_parenthesis
      signaling.onLocalStream = ((MediaStream stream) {
        try {
          notifyListeners();
          localRenderer.srcObject = stream;
        } catch (e) {
          debugPrint(e.toString());
        }
      });

      // ignore: unnecessary_parenthesis
      signaling.onReceivedAnswer = (() {
        isReceivedAnswer = true;
      });

      // ignore: unnecessary_parenthesis
      signaling.onAddRemoteStream = ((MediaStream stream) {
        try {
          notifyListeners();
          remoteRenderer.srcObject = stream;
        } catch (e) {
          debugPrint(e.toString());
        }
      });

      // ignore: unnecessary_parenthesis
      signaling.onRemoveRemoteStream = ((MediaStream stream) {
        remoteRenderer.srcObject = null;
      });

      // ignore: unnecessary_parenthesis
      signaling.onReceivedSocketWhenConnectCallback = ((Map<String, dynamic> data) {
        final List<String> friendIds = List<String>.from(data['friend_ids'] as List<dynamic>);
        socketHelper.setFriendsOnline(friends: friendIds);
      });

      // ignore: unnecessary_parenthesis
      signaling.onReceivedSocketFriendOnlineCallback = ((Map<String, dynamic> data) {
        socketHelper.addMemberOnline(uid: data['friend_id'] as String);
      });

      // ignore: unnecessary_parenthesis
      signaling.onReceivedSocketFriendOfflineCallback = ((Map<String, dynamic> data) {
        socketHelper.removeMemberOffline(uid: data['friend_id'] as String);
      });
    }
    final String token = await localStorage.getToken();
    debugPrint('token $token');
    debugPrint('isConnecting $_isConnecting');
    if (token != null && !_isConnecting) {
      await signaling.connect();
      _isConnecting = true;
    }
  }

  void closeSignal() {
    if(currentTimer != null) {
      currentTimer.cancel();
    }
    state = null;
    isReceivedAnswer = false;
    signaling.bye();
  }

  void disconnect() {

    signaling.close();
    signaling.closeSocket();
    _isConnecting = false;
    debugPrint('disconnect');
  }

  bool isShowCallingDialog = false;
  Future<void> checkCallNavigator(BuildContext context) async {
    print('checkCallNavigator $isShowCallingDialog');
    if (!isShowCallingDialog) {
      debugPrint('checkCallNavigator');
      isShowCallingDialog = true;
      await showDialog<dynamic>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CallingPopup(dialogContext: context);
          });
      isShowCallingDialog = false;
    }
  }

  Future<void> sendMessage({String peerId, bool inCalling = false}) async {
    try {
      if (currentMessage != null) {

        if (inCalling) {
          if (state == SignalingState.CallStateConnected) {
            await signaling.sendMessage(message: currentMessage, peerId: peerId);
            //Chat in Calling video
            messages.insert(0, CallMessageItem(message: currentMessage, isReceive: false));
            currentMessage = null;
            notifyListeners();
          }
        } else {
          //Chat in ChatRoom
          final Message message = Message();
          message.messageType = AppMessageType.send;
          message.createdAt = DateTime.now().toString();
          message.bodyMessage = BodyMessage(type: 'text', value: currentMessage);

          //Check current message is message from new day
          final DateTime date1 = DateTime.parse(message.createdAt).toLocal();
          final DateTime date2 = DateTime.parse(chatDetailProvider.messagesList.first.createdAt).toLocal();
          debugPrint('Date1: ${date1.day}');
          debugPrint('Date2: ${date2.day}');
          if (date1.day != date2.day) {
            message.isLastMessageInDay = true;
          }
          chatDetailProvider.addMessageToList(message: message);
          currentMessage = null;
          notifyListeners();
        }

      }
    } catch (e) {
      debugPrint('Send message error: ${e.toString()}');
    }
  }

}
