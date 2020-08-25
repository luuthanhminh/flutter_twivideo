
import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/base_response.dart';
import 'package:flirtbees/models/remote/message.dart';
import 'package:flirtbees/models/remote/request/messages/messages_list_request.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/services/remote/message_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatDetailProvider with ChangeNotifier {

  ChatDetailProvider(this.messageApi, this.localStorage);
  final LocalStorage localStorage;
  final MessageApi messageApi;

  bool isShownGiftView = false;
  bool isFavourite = false;
  List<Message> messagesList = <Message>[];
  Friend friend;
  int minIndexMessage = 0;

  List<MessageGift> messageGifts = const <MessageGift>[
    MessageGift(giftName: 'flower', minutes: 5),
    MessageGift(giftName: 'catGift', minutes: 10),
    MessageGift(giftName: 'diamond', minutes: 15),
    MessageGift(giftName: 'tsar', minutes: 20),
    MessageGift(giftName: 'strawberry', minutes: 25)];



  void setShownGiftView() {
    isShownGiftView = !isShownGiftView;
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void setFavored(bool isFavored) {
    isFavourite = isFavored;
    notifyListeners();
  }

  Future<List<Message>> getListMessage({int from, int to}) async {
    try {
      minIndexMessage = to;
      final MessageListRequest request = MessageListRequest(from: from, to: to);
      final Response<dynamic> result = await messageApi
          .getListMessage(rightId: friend.uid, request: request)
          .timeout(const Duration(seconds: 30));
      return (result.data['data'] as List<dynamic>).map((dynamic e) => Message.fromJson(e as Map<String, dynamic>)).toList();

    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
      return null;
    }
  }

  void addMessageToList({Message message}) {
    messagesList.insert(0, message);
    notifyListeners();
  }

  Future<void> setMessageList({List<Message> messages}) async {
    final String selfId = await localStorage.getUserId();
    for (int i = 0; i < messages.length; i++) {
      final Message msg = messages[i];
      if (msg.left == selfId) {
        msg.messageType = AppMessageType.send;
      } else {
        msg.messageType = AppMessageType.receive;
      }
      messagesList.add(msg);
      if (messages.length > 2) {
        if (i < messages.length - 1) {
          final DateTime date1 = DateTime.parse(messages[i].createdAt).toLocal();
          final DateTime date2 = DateTime.parse(messages[i + 1].createdAt).toLocal();
          if (date1.day != date2.day) {
            messagesList[i].isLastMessageInDay = true;
          }
        }
      }
    }

    notifyListeners();

  }

}