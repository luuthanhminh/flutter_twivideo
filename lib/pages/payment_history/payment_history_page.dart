
import 'package:flirtbees/pages/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';
import '../../utils/app_style.dart';
import '../../utils/utils.dart';
import '../../widgets/app_header.dart';

class PaymentHistoryPage extends StatefulWidget {
  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
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
          title: 'Payment history',
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
                      child: Text('Time in chat', style: normalTextStyle(14.SP, Colors.black),)
                    ),
                    Flexible(
                      child: Text('- 39 minutes', style: normalTextStyle(14.SP, Colors.black),),
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
                        child: Text('Account top-up', style: normalTextStyle(14.SP, Colors.black),)
                    ),
                    Flexible(
                      child: Text('+ 20 minutes', style: normalTextStyle(14.SP, AppColors.jadeGreen),),
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
