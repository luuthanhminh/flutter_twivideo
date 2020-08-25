
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flirtbees/utils/app_config.dart';

class Api {

  Api(this.localStorage) {
    if (!kReleaseMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true));
    }
  }

  // Get base url by env
  //Auth
  static final String apiBaseUrl = Config.instance.env.apiBaseUrl;

  static final String guestUrl = '$apiBaseUrl/api/auth/guest';
  static final String loginUrl = '$apiBaseUrl/api/auth/firebase';
  static final String userUrl = '$apiBaseUrl/api/users';
  static final String avatarUrl = '$apiBaseUrl/api/users/avatar';
  static final String realtimeUrl = '$apiBaseUrl/api/realtime';
  static final String updateNotificationTokenUrl = '$apiBaseUrl/api/notifications/token';

 //Friends
  static final String friendRequest = '$apiBaseUrl/api/friends/request';
  static final String friendAccept = '$apiBaseUrl/api/friends/accept';
  static final String friendDecline = '$apiBaseUrl/api/friends/decline';
  static final String friendFavourite = '$apiBaseUrl/api/friends/favorite';
  static final String friendList = '$apiBaseUrl/api/friends/all';
  static final String unfriend = '$apiBaseUrl/api/friends/unfriend';

  //Histories
  static final String allHistories = '$apiBaseUrl/api/histories/all';

  //Messages
  static final String messageListUrl = '$apiBaseUrl/api/messages/';

  final Dio dio = Dio();
  final LocalStorage localStorage;
  // Get header
  Future<Map<String, String>> getHeader() async {
    final Map<String, String> header = <String, String>{
      'content-type': 'application/json'
    };
    return header;
  }


  // Get header
  Future<Map<String, String>> getAuthHeader() async {
    final Map<String, String> header = await getHeader();
    final String token = await localStorage.getToken();
    header.addAll(<String, String>{'Authorization': 'Bearer $token'});
    return header;
  }

  // Wrap Dio Exception
  Future<Response<dynamic>> wrapE(
      Future<Response<dynamic>> Function() dioApi) async {
    try {
      return await dioApi();
    } catch (error) {
      if (error is DioError && error.type == DioErrorType.RESPONSE) {
        final Response<dynamic> response = error.response;
        /// if you want by pass dio header error code to get response content
        /// just uncomment line below
        //return response;
        switch (response.statusCode) {
          case 401:
            throw AuthorizationDioError(
                error.request,
                error.response,
                error.type,
                error.message
            );
        }

        final String errorMessage =
            'Code ${response.statusCode} - ${response.statusMessage} ${response.data != null ? '\n' : ''} ${response.data}';
        throw DioError(
            request: error.request,
            response: error.response,
            type: error.type,
            error: errorMessage);
      }
      rethrow;
    }
  }
}

class AuthorizationDioError extends DioError {

  AuthorizationDioError(
      RequestOptions request,
      Response<dynamic> response,
      DioErrorType type,
      String errorMessage) : super(
      request: request,
      response: response,
      type: type,
      error: errorMessage
  );
}