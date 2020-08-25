
import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/base_response.dart';
import 'package:flirtbees/models/remote/response/friends/boolean_response.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/models/remote/response/friends/request_friend_response.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/services/remote/friend_api.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FriendRequestProvider with ChangeNotifier {
  FriendRequestProvider(this.callingProvider, this.friendApi);

  final CallingProvider callingProvider;
  final FriendApi friendApi;

  bool isRequested = false;
  bool isFavored = false;

  Friend currentFriend;

  void clearData() {
    isRequested = false;
    isFavored = false;
    currentFriend = null;
  }

  Future<bool> sendRequestFriend({String friendId}) async {
    try {
      final Response<dynamic> result = await friendApi.requestFriend(friendId: friendId).timeout(const Duration(seconds: 30));
      final FriendRequestResponse friendRequestResponse = FriendRequestResponse(result.data as Map<String, dynamic>);
      if (friendRequestResponse.data.left != null && friendRequestResponse.data.right != null) {
        isRequested = true;
        notifyListeners();
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

  Future<bool> cancelRequestFriend({String friendId}) async {
    try {
      final Response<dynamic> result = await friendApi.cancelRequestFriend(friendId: friendId).timeout(const Duration(seconds: 30));
      final BooleanResponse booleanResponse = BooleanResponse(result.data as Map<String, dynamic>);
      if (booleanResponse.isSuccessed) {
        isRequested = false;
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
        isFavored = true;
        notifyListeners();
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
      if (booleanResponse.isSuccessed) {
        isFavored = false;
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

}