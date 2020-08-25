import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/base_response.dart';
import 'package:flirtbees/models/remote/login_firebase_response.dart';
import 'package:flirtbees/models/remote/request/update_notification_request.dart';
import 'package:flirtbees/models/remote/response/update_notification_response.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/services/remote/user_api.dart';
import 'package:flirtbees/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/services/remote/auth_api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthProvider with ChangeNotifier {

  AuthProvider(this.authApi, this.localStorage, this.loginProvider, this.userApi);
  bool isRegisterSuccessfully = false;
  String fcmToken;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebooklogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalStorage localStorage;
  final AuthApi authApi;
  final LoginProvider loginProvider;
  final UserApi userApi;

  Future<FirebaseUser> handleSignInGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  Future<FirebaseUser> handleSignInApple() async {
    final AuthorizationCredentialAppleID credentialApple = await SignInWithApple.getAppleIDCredential(
      // ignore: always_specify_types
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    const OAuthProvider oAuthProvider = OAuthProvider(providerId: 'apple.com');
    final AuthCredential credential = oAuthProvider.getCredential(
      idToken: credentialApple.identityToken,
      accessToken: credentialApple.authorizationCode,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    return user;
  }

  Future<FirebaseUser> handleSignInFacebook() async {
    final FacebookLoginResult result = await _facebooklogin.logIn(['email']);
    debugPrint(result.accessToken.token);
    debugPrint('facebook auth status=${result.status}');

    final AuthCredential facebookAuthCred =
    FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
    final FirebaseUser user = (await _auth.signInWithCredential(facebookAuthCred)).user;
    final IdTokenResult tokenID = await user.getIdToken();
    debugPrint(tokenID.token);
    return user;
  }

  Future<void> handleLogout() async {
    try {
      final GoogleSignInAccount _ = await _googleSignIn.disconnect();
      await _auth.signOut();
      await _facebooklogin.logOut();
      await localStorage.setToken();
      loginProvider.setLogout();
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<void> sendFirebaseTokenToServer({String token, Function(bool isSuccess, String messages, User user) callback}) async {
    try {
      log(token);
      final Response<dynamic> result = await authApi
          .signInWithFirebase(token)
          .timeout(const Duration(seconds: 30));
      final FirebaseLoginResponse firebaseLoginResponse =
      FirebaseLoginResponse(result.data as Map<String, dynamic>);
      isRegisterSuccessfully = true;
      await localStorage.setToken(token: firebaseLoginResponse.data.accessToken);
      loginProvider.setLoggedIn();
      if (firebaseLoginResponse.data.user.uid != null) {
        debugPrint('UserID: ${firebaseLoginResponse.data.user.uid}');
        final String deviceID = await AppHelper.getDeviceUUID();
        await updateNotificationToken(UpdateNotificationRequest(fcmToken: fcmToken, deviceId: deviceID));
        await localStorage.saveGuestUserStatus(isGuestUser: false);
        await localStorage.setUserId(id: firebaseLoginResponse.data.user.uid);
      }
        callback(true, null, firebaseLoginResponse.data.user);
        notifyListeners();
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
        callback(false, e.message, null);
      } else {
        Fluttertoast.showToast(msg: e.toString());
        callback(false, e.toString(), null);
      }

    }
  }


  Future<void> guestLogin({Function(bool isSuccess, String messages, User user) callback}) async {
    try {
      final Response<dynamic> result = await authApi
          .guestLogin()
          .timeout(const Duration(seconds: 30));
      final FirebaseLoginResponse firebaseLoginResponse =
      FirebaseLoginResponse(result.data as Map<String, dynamic>);
      isRegisterSuccessfully = true;
      await localStorage.setToken(token: firebaseLoginResponse.data.accessToken);
      loginProvider.setLoggedIn();
      if (firebaseLoginResponse.data.user.uid != null) {
        debugPrint('UserID: ${firebaseLoginResponse.data.user.uid}');
        await localStorage.setUserId(id: firebaseLoginResponse.data.user.uid);
      }
      callback(true, null, firebaseLoginResponse.data.user);
      notifyListeners();
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
        callback(false, e.message, null);
      } else {
        Fluttertoast.showToast(msg: e.toString());
        callback(false, e.toString(), null);
      }
    }
  }

  Future<UpdateNotificationResponse> updateNotificationToken(UpdateNotificationRequest request) async {
    try {
      final Response<dynamic> result = await userApi
          .updateNotificationToken(request)
          .timeout(const Duration(seconds: 30));
      final UpdateNotificationResponse updateNotificationResponse =
      UpdateNotificationResponse(result.data as Map<String, dynamic>);
      if (updateNotificationResponse.data.uid != null && updateNotificationResponse.data.fcmToken != null) {
        return updateNotificationResponse;
      }
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
      return null;
    }
  }

}
