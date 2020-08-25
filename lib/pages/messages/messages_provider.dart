import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/base_response.dart';
import 'package:flirtbees/models/remote/response/friends/boolean_response.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/models/remote/response/friends/request_friend_response.dart';
import 'package:flirtbees/pages/messages/messages_page.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/services/remote/api.dart';
import 'package:flirtbees/services/remote/friend_api.dart';
import 'package:flirtbees/services/remote/message_api.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessagesProvider with ChangeNotifier {
  MessagesProvider(this.friendApi, this.localStorage);

  bool isEditing = false;
  bool isExpanded = true;
  List<int> selectedIndexes = <int>[];
  List<MessageSlot> allMessages = <MessageSlot>[];
  List<MessageSlot> messageThreads = <MessageSlot>[];
  List<Friend> friendList = <Friend>[];

  bool get isSelecting => selectedIndexes.isNotEmpty;
  int currentSelectedIndex;
  final FriendApi friendApi;
  final LocalStorage localStorage;

  void toggleEditing() {
    isEditing = !isEditing;
    if (isEditing) {
      selectedIndexes.clear();
    }
    notifyListeners();
  }

  void toggleExpand() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  void setExpand(bool expand) {
    isExpanded = expand;
    notifyListeners();
  }

  void addSelectedIndexes(int index) {
    if (!selectedIndexes.contains(index)) {
      selectedIndexes.add(index);
    } else {
      selectedIndexes.remove(index);
    }
    notifyListeners();
  }

  Future<void> getListFriends({Function onAuthorizationDioError}) async {
    try {
      final Response<dynamic> result = await friendApi
          .getListFriends()
          .timeout(const Duration(seconds: 30));
      debugPrint('All message: ${result.data['data']}');
      final List<Friend> friendListResponseResponse =  (result.data['data'] as List<dynamic>).map((dynamic e) => Friend.fromJson(e as Map<String, dynamic>)).toList();
      debugPrint('Message count ${friendListResponseResponse.length}');
      friendList = friendListResponseResponse;
      allMessages = friendListResponseResponse.map((Friend e) =>
          MessageSlot(friend: e,)
          ).toList();
      messageThreads = allMessages;
      notifyListeners();
    } on AuthorizationDioError {
      onAuthorizationDioError();
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<bool> unFriend({String friendId}) async {
    try {
      final Response<dynamic> result = await friendApi.unfriend(friendId: friendId).timeout(const Duration(seconds: 30));
      final BooleanResponse booleanResponse = BooleanResponse(result.data as Map<String, dynamic>);
      if (booleanResponse.isSuccessed) {
        notifyListeners();
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

  Future<bool> favouriteFriend({String friendId}) async {
    try {
      final Response<dynamic> result = await friendApi.favouriteFriend(friendId: friendId).timeout(const Duration(seconds: 30));
      final FriendRequestResponse friendRequestResponse = FriendRequestResponse(result.data as Map<String, dynamic>);
      if (friendRequestResponse.data.left != null && friendRequestResponse.data.right != null) {
        return true;
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

  Future<bool> deleteFavouriteFriend({String friendId}) async {
    try {
      final Response<dynamic> result = await friendApi.deleteFavouriteFriend(friendId: friendId).timeout(const Duration(seconds: 30));
      final BooleanResponse booleanResponse = BooleanResponse(result.data as Map<String, dynamic>);
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

  void filterMessage({MessageFilter type}) {
    switch (type) {
      case MessageFilter.all:
      case MessageFilter.unread:
        messageThreads = allMessages;
        break;
      case MessageFilter.favourites:
        messageThreads = allMessages.where((MessageSlot i) => i.friend.isFavorite).toList();
        break;
      case MessageFilter.friendOnline:
        messageThreads = allMessages.where((MessageSlot i) => i.friend.isFullFriend).toList();
        break;
    }
    notifyListeners();
  }

  void updateFriendMessageList({List<MessageSlot> list}) {
    allMessages = list;
    messageThreads = allMessages;
    notifyListeners();
  }

}

enum MessageFilter {
  all,
  friendOnline,
  favourites,
  unread
}