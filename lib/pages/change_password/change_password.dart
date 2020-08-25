
import 'package:flirtbees/pages/change_password/change_password_provider.dart';
import 'package:flirtbees/pages/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_style.dart';
import '../../utils/utils.dart';
import '../../widgets/app_header.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangePasswordProvider>(
      create: (_) => ChangePasswordProvider(),
      builder: (BuildContext context, _) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppHeader(
                leading: InkWell(
                  onTap: () async {
                    Provider.of<SettingsProvider>(context, listen: false).currentIndex = -1;
                    final bool maybePop = await Navigator.maybePop(context);
                    if (!maybePop) {
                      Navigator.pushReplacementNamed(context, AppConstant.settingsPageRoute);
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset(AppImages.icBack, color: AppColors.darkGreyBlue,),
                      SizedBox(width: 10.W,),
                      Text('Settings', style: normalTextStyle(17.SP, AppColors.darkGreyBlue),)
                    ],
                  ),
                ),
                title: 'Change password',
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.W),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 33.H,),
                    Container(
                      height: 31.H,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onChanged: (String newText) {
                                Provider.of<ChangePasswordProvider>(context, listen: false).newPassword = newText;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                hintStyle: normalTextStyle(14.SP, AppColors.steel),
                                hintText: 'New password',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 20.H),
                              ),
                            ),
                          ),
                          Container(
                            width: 20.W,
                            height: 12.H,
                            child: Image.asset(AppImages.icEyeGrey),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: AppColors.warmGrey2,
                    ),
                    SizedBox(height: 14.H,),
                    Container(
                      height: 31.H,
                      width: ScreenUtil.screenWidthDp,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onChanged: (String newText) {
                                Provider.of<ChangePasswordProvider>(context, listen: false).confirmPassword = newText;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                hintStyle: normalTextStyle(14.SP, AppColors.steel),
                                hintText: 'Retype password',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 20.H),
                              ),
                            ),
                          ),
                          Container(
                            width: 20.H,
                            height: 12.W,
                            child: Image.asset(AppImages.icEyeGrey),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: AppColors.warmGrey2,
                    ),
                    SizedBox(height: 49.H),
                    Container(
                      height: 49.H,
                      width: ScreenUtil.screenWidthDp,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.jadeGreen
                      ),
                      child: InkWell(
                        onTap: () {

                        },
                        child: Center(
                          child: Text(
                              'Save', style: boldTextStyle(16.SP, Colors.white)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.H,),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
