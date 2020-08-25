import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/login_firebase_response.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/services/remote/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/services/remote/auth_api.dart';

class LoginProvider with ChangeNotifier {
  LoginProvider(this.authApi, this.userApi, this.localStorage);

  bool isLoggedIn = false;
  bool isButtonsEnable = true;
  final AuthApi authApi;
  final UserApi userApi;
  final LocalStorage localStorage;

  Future<void> sendFirebaseTokenToServer(String token) async {
    final Response<dynamic> result = await authApi
        .signInWithFirebase(token)
        .timeout(const Duration(seconds: 30));
    final FirebaseLoginResponse firebaseLoginResponse =
        FirebaseLoginResponse(result.data as Map<String, dynamic>);
    await localStorage.setToken(token: firebaseLoginResponse.data.accessToken);
    setLoggedIn();
    notifyListeners();
  }

  Future<bool> getLoggedStatus() async {
    // ignore: join_return_with_assignment
    isLoggedIn = await localStorage.getToken() != null;
    return isLoggedIn;
  }

  void setLoggedIn() {
    isLoggedIn = true;
    notifyListeners();
  }

  void setLogout() {
    isLoggedIn = false;
    notifyListeners();
  }
}
