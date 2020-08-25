
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'api.dart';

class AuthApi extends Api {
  AuthApi({LocalStorage token}) : super(token);

  /// Login
  Future<Response<dynamic>> signInWithFirebase(String token) async {
    final Map<String, String> header = await getHeader();
    return wrapE(() => dio.post<dynamic>(Api.loginUrl,
        options: Options(headers: header),
        data: json.encode(<String, String>{
          'token': token
        })));
  }

  /// Guest Login
  Future<Response<dynamic>> guestLogin() async {
    final Map<String, String> header = await getHeader();
    return wrapE(() => dio.post<dynamic>(Api.guestUrl,
        options: Options(headers: header),
        data: null));
  }

  /// Login With Error
  Future<Response<dynamic>> signInWithError() async {
    final Map<String, String> header = await getHeader();
    return wrapE(() => dio.post<dynamic>('https://nhancv.free.beeceptor.com/login-err',
        options: Options(headers: header),
        data: json.encode(<String, String>{
          'username': 'username',
          'password': 'password',
        })));
  }
}
