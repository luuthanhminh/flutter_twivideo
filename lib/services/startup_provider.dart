
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/utils/app_constant.dart';
import 'package:flutter/material.dart';

class StartupProvider with ChangeNotifier {
  StartupProvider(this.localStorage, this.loginProvider);

  final LocalStorage localStorage;
  final LoginProvider loginProvider;
  String startupScreenRoute = AppConstant.homePageRoute;

  void updateStartupScreen(String newRoute) {
    if(startupScreenRoute != newRoute) {
      startupScreenRoute = newRoute;
      notifyListeners();
    }
  }


  Future<void> verifyStartupScreen() async {
    final bool isSelectedGender = await localStorage.isSelectedGender();
    final bool isAceptUserAgreement = await localStorage.getAcceptAgreementStatus();
    final String isHaveToken = await localStorage.getToken();
    final bool isGuestUser = await localStorage.isGuestUser();
    if (isHaveToken != null &&  isGuestUser != true) {
      loginProvider.setLoggedIn();
    } else {
      loginProvider.setLogout();
    }
    notifyListeners();
    if (!isAceptUserAgreement) {
      updateStartupScreen(AppConstant.userAgreementPageRoute);
    } else {
      if (isSelectedGender) {
        updateStartupScreen(AppConstant.homePageRoute);
      } else {
        updateStartupScreen(AppConstant.genderSelectPageRoute);
      }
    }

  }
}