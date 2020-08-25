import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/services/remote/auth_api.dart';

class RegisterProvider with ChangeNotifier {

  RegisterProvider(this.authApi, this.localStorage, this.loginProvider);
  bool isRegisterSuccessfully = false;

  final LocalStorage localStorage;
  final AuthApi authApi;
  final LoginProvider loginProvider;


}
