
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/request/friends/accept_friend.dart';
import 'package:flirtbees/models/remote/request/friends/request_friend.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'api.dart';

class FriendApi extends Api {

  FriendApi(LocalStorage localStorage) : super(localStorage);

  Future<Response<dynamic>> requestFriend({String friendId}) async {
    final RequestFriend requestFriend = RequestFriend(right: friendId);
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.post<dynamic>(Api.friendRequest,
        options: Options(headers: header),
        data: json.encode(requestFriend.toJson())));
  }

  Future<Response<dynamic>> cancelRequestFriend({String friendId}) async {
    final RequestFriend requestFriend = RequestFriend(right: friendId);
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.delete<dynamic>(Api.friendRequest,
        options: Options(headers: header),
        data: json.encode(requestFriend.toJson())));
  }

  Future<Response<dynamic>> acceptFriend({String friendId}) async {
    final AcceptFriend acceptFriend = AcceptFriend(left: friendId);
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.post<dynamic>(Api.friendAccept,
        options: Options(headers: header),
        data: json.encode(acceptFriend.toJson())));
  }

  Future<Response<dynamic>> declineFriend({String friendId}) async {
    final DeclineFriend declineFriend = DeclineFriend(left: friendId);
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.post<dynamic>(Api.friendDecline,
        options: Options(headers: header),
        data: json.encode(declineFriend.toJson())));
  }

  Future<Response<dynamic>> favouriteFriend({String friendId}) async {
    final FavouriteFriend favouriteFriend = FavouriteFriend(right: friendId);
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.post<dynamic>(Api.friendFavourite,
        options: Options(headers: header),
        data: json.encode(favouriteFriend.toJson())));
  }

  Future<Response<dynamic>> deleteFavouriteFriend({String friendId}) async {
    final FavouriteFriend favouriteFriend = FavouriteFriend(right: friendId);
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.delete<dynamic>(Api.friendFavourite,
        options: Options(headers: header),
        data: json.encode(favouriteFriend.toJson())));
  }

  Future<Response<dynamic>> unfriend({String friendId}) async {
    final FavouriteFriend unFriend = FavouriteFriend(right: friendId);
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.delete<dynamic>(Api.unfriend,
        options: Options(headers: header),
        data: json.encode(unFriend.toJson())));
  }

  Future<Response<dynamic>> getListFriends() async {
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.get<dynamic>(Api.friendList,
        options: Options(headers: header)));
  }

  Future<Response<dynamic>> getListHistories() async {
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.get<dynamic>(Api.allHistories,
        options: Options(headers: header)));
  }

}
