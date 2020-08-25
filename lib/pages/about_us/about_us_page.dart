
import 'package:flirtbees/pages/settings/settings_provider.dart';
import 'package:flirtbees/utils/app_color.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
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
          title: 'About us',
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.W),
          child: Column(
            children: <Widget>[
              SizedBox(height: 28.H,),
              Center(
                child: Container(
                  width: 60.W, height: 60.H,
                    child: ClipRRect(borderRadius: BorderRadius.circular(13.3), child: Image.asset(AppImages.icAppIcon))),
              ),
              SizedBox(height: 8.H,),
              Center(child: Text('Version: 1.1.18', style: normalTextStyle(12.SP, AppColors.warmGrey),),),
              SizedBox(height: 2.H,),
              Center(child: Text('Build 221', style: normalTextStyle(12.SP, AppColors.warmGrey),),),
              SizedBox(height: 24.H,),
              Container(
                width: ScreenUtil.screenWidthDp,
                child: Text("""Flirtbees offers innovative video chat with casual partners. Our advantages are 100% reliability and high speeds! Our chat doesn't stop for a second - you can find thousands of users from around the world here all day.""",
                style: normalTextStyle(14, Colors.black),),
              ),
              SizedBox(height: 56.H,),
              Container(
                height: 45.H,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Text('User Agreement', style: normalTextStyle(14.SP, Colors.black),)
                    ),
                    Container(
                      width: 6.W,
                      height: 10.H,
                      child: Image.asset(AppImages.icArrowRightBlack),
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
                        child: Text('Privacy Policy', style: normalTextStyle(14.SP, Colors.black),)
                    ),
                    Container(
                      width: 6.W,
                      height: 10.H,
                      child: Image.asset(AppImages.icArrowRightBlack),
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
