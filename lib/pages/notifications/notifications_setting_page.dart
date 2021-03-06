import 'package:flirtbees/pages/settings/settings_provider.dart';
import 'package:flirtbees/utils/app_style.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/app_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsSettingPage extends StatefulWidget {
  @override
  _NotificationsSettingPageState createState() => _NotificationsSettingPageState();
}

class _NotificationsSettingPageState extends State<NotificationsSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
          title: 'Notifications',
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.W),
          child: Column(
            children: <Widget>[
              SizedBox(height: 19.H,),
              Container(
                height: 45.H,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Text('Activity related to your profile', style: normalTextStyle(14.SP, Colors.black),)
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: false,
                        onChanged: (bool value) async {

                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppColors.warmGrey2,
              ),
              Container(
                height: 45.H,
                width: ScreenUtil.screenWidthDp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Text('Latest news about our service', style: normalTextStyle(14.SP, Colors.black),)
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: false,
                        onChanged: (bool value) async {

                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppColors.warmGrey2,
              ),
              Container(
                height: 45.H,
                width: ScreenUtil.screenWidthDp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Text('Messages from our partners', style: normalTextStyle(14.SP, Colors.black), textAlign: TextAlign.left,)
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: true,
                        onChanged: (bool value) async {

                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppColors.warmGrey2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
