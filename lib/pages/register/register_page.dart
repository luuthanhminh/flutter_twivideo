import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/authentication/auth_provider.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/pages/profile/profile_provider.dart';
import 'package:flirtbees/pages/register/register_provider.dart';
import 'package:flirtbees/pages/register_profile/register_profile.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  @override
  void initState() {
    super.initState();
  }

  // ignore: avoid_void_async
  void handleRegister({FirebaseUser firebaseUser}) async {
    context.read<AppLoadingProvider>().showLoading(context);
    final IdTokenResult tokenId = await firebaseUser.getIdToken();
    if (tokenId.token.toString() != null) {
      context.read<AuthProvider>().sendFirebaseTokenToServer(token: tokenId.token.toString(), callback: (bool isSuccess, String msg, User user) {
        context.read<AppLoadingProvider>().hideLoading();
        if (isSuccess) {
          context.read<CallingProvider>().connect(context);
          context.read<LoginProvider>().setLoggedIn();
          if (user != null) {
            context.read<ProfileProvider>().userName = user.name;
            context.read<ProfileProvider>().networkAvatar = user.avatar;
            context.read<ProfileProvider>().email = user.email;
            showCupertinoModalBottomSheet<dynamic>(
                expand: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context, ScrollController scrollController) =>
                    RegisterProfilePage()
            );

          }
        } else {
          Fluttertoast.showToast(msg: msg);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    NestedNavigatorsBlocProvider.of(context).setTabBarVisibility(false);
    return Consumer<RegisterProvider>(
      builder: (BuildContext context, RegisterProvider provider, _) {
        if (!provider.isRegisterSuccessfully) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.W),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Container(
                  margin: EdgeInsets.only(top: 28.H),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget> [
                      Text('Register', style: boldTextStyle(34.SP, Colors.black),),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(AppImages.icCloseBlack),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 36.H,),
                if (Platform.isIOS) Container(
                  height: 49.H,
                  width: ScreenUtil.screenWidthDp,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.warmGrey2)
                  ),
                  child: InkWell(
                    onTap: () async {
                      final FirebaseUser firebaseUser = await context.read<AuthProvider>().handleSignInApple();
                      handleRegister(firebaseUser: firebaseUser);
                    },
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 17.H,
                                height: 17.H,
                                child: Image.asset(AppImages.icApple)),
                            SizedBox(width: 5.W,),
                            Text('Sign in with Apple', style: normalTextStyle(16, Colors.black),)
                          ],
                        )
                    ),
                  ),
                ) else Container(),
                SizedBox(height: 8.H,),
                Container(
                  height: 49.H,
                  width: ScreenUtil.screenWidthDp,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.denimBlue
                  ),
                  child: InkWell(
                    onTap: () async {
                      final FirebaseUser firebaseUser = await context.read<AuthProvider>().handleSignInFacebook();
                      handleRegister(firebaseUser: firebaseUser);
                    },
                    child: Center(
                        child: Image.asset(AppImages.icSigninFacebook)
                    ),
                  ),
                ),
                SizedBox(height: 8.H,),
                Container(
                  height: 49.H,
                  width: ScreenUtil.screenWidthDp,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.warmGrey2)
                  ),
                  child: InkWell(
                    onTap: () async {
                      final FirebaseUser firebaseUser = await context.read<AuthProvider>().handleSignInGoogle();
                      handleRegister(firebaseUser: firebaseUser);
                    },
                    child: Center(
                        child: Image.asset(AppImages.icSigninGoogle)
                    ),
                  ),
                ),
                SizedBox(height: 8.H,),
                SizedBox(height: 24.H),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Center(
                      child: Row(
                        children: <Widget> [
                          Text('Already have an account?', style: normalTextStyle(14, Colors.black),),
                          SizedBox(width: 2.W,),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppConstant.loginPageRoute);
                            },
                            child: Text('Sign in', style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 14.SP,
                                color: AppColors.darkGreyBlue
                            ),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      }
    );
  }
}
