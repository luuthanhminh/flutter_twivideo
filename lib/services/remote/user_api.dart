
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/request/update_notification_request.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'api.dart';

class UserApi extends Api {

  UserApi(LocalStorage localStorage) : super(localStorage);

  Future<Response<dynamic>> updateUserInfo(User info) async {
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.post<dynamic>(Api.userUrl,
        options: Options(headers: header),
        data: json.encode(info.toJson())));
  }

  Future<Response<dynamic>> getUserInfo() async {
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.get<dynamic>(Api.userUrl,
        options: Options(headers: header)));
  }

  Future<Response<dynamic>> updateAvatar(String path) async {
    final Map<String, String> header = await getAuthHeader();
    final FormData formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(path, filename: 'avatar')
    });
    return wrapE(() => dio.post<dynamic>(Api.avatarUrl,
        options: Options(headers: header),
        data: formData));
  }

  Future<Response<dynamic>> getRandom() async {
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.get<dynamic>(Api.realtimeUrl,
        options: Options(headers: header)));
  }

  Future<Response<dynamic>> updateNotificationToken(UpdateNotificationRequest request) async {
    final Map<String, String> header = await getAuthHeader();
    return wrapE(() => dio.post<dynamic>(Api.updateNotificationTokenUrl,
        options: Options(headers: header),
        data: json.encode(request.toJson())));
  }
}
