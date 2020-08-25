import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/base_response.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/services/remote/api.dart';
import 'package:flirtbees/services/remote/friend_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistoryProvider with ChangeNotifier {
  HistoryProvider(this.friendApi, this.localStorage);


  List<Friend> historiesList = <Friend>[];

  final FriendApi friendApi;
  final LocalStorage localStorage;

  int currentIndex = 0;

  Future<void> getListHistories({Function onAuthorizationDioError}) async {
    try {
      final Response<dynamic> result = await friendApi
          .getListHistories()
          .timeout(const Duration(seconds: 30));
      historiesList =  (result.data['data'] as List<dynamic>).map((dynamic e) => Friend.fromJson(e as Map<String, dynamic>)).toList();
      notifyListeners();
    } on AuthorizationDioError {
      onAuthorizationDioError();
    }catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }
}

