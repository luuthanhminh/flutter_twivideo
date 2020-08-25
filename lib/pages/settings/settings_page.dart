import 'package:flirtbees/pages/about_us/about_us_page.dart';
import 'package:flirtbees/pages/change_password/change_password.dart';
import 'package:flirtbees/pages/content_settings/content_settings.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/pages/notifications/notifications_setting_page.dart';
import 'package:flirtbees/pages/payment_history/payment_history_page.dart';
import 'package:flirtbees/pages/profile/profile_page.dart';
import 'package:flirtbees/pages/settings/settings_provider.dart';
import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/app_style.dart';
import 'package:flirtbees/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../utils/app_constant.dart';
import '../login/login_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> settingsList = <String>[
    'Personal information',
    'Change password',
    'Notifications',
    'Content Settings',
    'Payment history',
    'About us'
  ];

  Widget navigateToSettingChildPagePage({int index}) {
    switch (index) {
      case 0:
        return ProfilePage();
      case 1:
        return ChangePasswordPage();
      case 2:
        return NotificationsSettingPage();
      case 3:
        return ContentSettingsPage();
      case 4:
        return PaymentHistoryPage();
      case 5:
        return AboutUsPage();
      default:
        return null;
    }

  }


  @override
  Widget build(BuildContext context) {
    final Widget correspondingWidget = navigateToSettingChildPagePage(index: Provider.of<SettingsProvider>(context, listen: false).currentIndex);
    if (correspondingWidget != null) {
      return correspondingWidget;
    }
    return Column(
      children: <Widget>[
        AppHeader(
          leading: Text('', style: normalTextStyle(17.SP, AppColors.darkGreyBlue)),
          title: 'Settings',
        ),
        SizedBox(
          height: 20.H,
        ),
        Flexible(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: settingsList.length,
              itemBuilder: (BuildContext context, int index) {
                final
                // ignore: unnecessary_parenthesis
                bool isEnable = (index == 5 || Provider.of<LoginProvider>(context).isLoggedIn);
                  return InkWell(
                    onTap: () {
                      context.read<SettingsProvider>().currentIndex = index;
                      if (context.read<LoginProvider>().isLoggedIn || index == 5) {
                        Navigator.pushNamed(context, AppConstant.settingsPageRoute);
                      }
                    },
                    splashColor: Colors.transparent,
                      child: SettingsItem(title: settingsList[index], isEnable: isEnable,));
              }
          ),
        ),
        SizedBox(height: 14.H),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('User id: 15940462642914', style: normalTextStyle(12, AppColors.warmGrey2),)
          ],
        )
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({Key key, this.title, this.isEnable}) : super(key: key);
  final String title;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    final Color textColor = isEnable ? Colors.black : AppColors.warmGrey2;
    final String imageName = isEnable ? AppImages.icArrowRightBlack : AppImages.icArrowRightGrey;


    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.W),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 14.H,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: normalTextStyle(14, textColor),),
              Image.asset(imageName)
            ],
          ),
          SizedBox(height: 14.H,),
          Container(height: 1, color: AppColors.warmGrey2,)
        ],
      ),
    );
  }
}

