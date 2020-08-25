
import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/base_response.dart';
import 'package:flirtbees/models/remote/response/friends/boolean_response.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/services/remote/friend_api.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccpetFriendProvider with ChangeNotifier {

  AccpetFriendProvider(this.friendApi);

  final FriendApi friendApi;
  Friend friend;

  Future<bool> acceptFriend() async {
    try {
      final Response<dynamic> result = await friendApi.acceptFriend(friendId: friend.uid).timeout(const Duration(seconds: 30));
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

  Future<bool> declineFriend() async {
    try {
      final Response<dynamic> result = await friendApi.declineFriend(friendId: friend.uid).timeout(const Duration(seconds: 30));
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

}