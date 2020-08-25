import 'package:flutter/material.dart';
import 'package:flirtbees/utils/utils.dart';

class HistorySettingsPage extends StatefulWidget {
  @override
  _HistorySettingsPageState createState() => _HistorySettingsPageState();
}

class _HistorySettingsPageState extends State<HistorySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.W, vertical: 34.H),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.W),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 49.5.H,
                      child: Center(
                        child: Text('Nadezhda', style: normalTextStyle(18.SP, Colors.black),),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: AppColors.warmGrey2,
                    )
                  ],
                ),
                Container(
                  height: 49.H,
                  child: Row(
                    children: <Widget>[
                      Container(height: 20.H, width: 20.W, child: Image.asset(AppImages.icBlock),),
                      SizedBox(width: 9.W,),
                      Text('Block this contact', style: normalTextStyle(14.SP, AppColors.fireEngineRed),)
                    ],
                  ),

                ),
                Container(height: 1.H, color: AppColors.warmGrey2,),
                Container(
                  height: 49.H,
                  child: Row(
                    children: <Widget>[
                      Container(height: 20.H, width: 20.W, child: Image.asset(AppImages.icMail),),
                      SizedBox(width: 9.W,),
                      Text('Spam', style: normalTextStyle(14.SP, Colors.black),)
                    ],
                  ),
                ),
                Container(height: 1.H, color: AppColors.warmGrey2,),
                Container(
                  height: 49.H,
                  child: Row(
                    children: <Widget>[
                      Container(height: 25.H, width: 16.W, child: Image.asset(AppImages.icBikini),),
                      SizedBox(width: 9.W,),
                      Text('Contains nudity or pornography', style: normalTextStyle(14.SP, Colors.black),)
                    ],
                  ),
                ),
                Container(height: 1.H, color: AppColors.warmGrey2,),
                Container(
                  height: 49.H,
                  child: Row(
                    children: <Widget>[
                      Container(height: 20.H, width: 20.W, child: Image.asset(AppImages.icBaby),),
                      SizedBox(width: 9.W,),
                      Text('Child endangerment (exploitation)', style: normalTextStyle(14.SP, Colors.black),)
                    ],
                  ),
                ),
                Container(height: 1.H, color: AppColors.warmGrey2,),
                Container(
                  height: 49.H,
                  child: Row(
                    children: <Widget>[
                      Container(height: 20.H, width: 20.W, child: Image.asset(AppImages.icExclamation),),
                      SizedBox(width: 9.W,),
                      Text('Harrassment or threats', style: normalTextStyle(14.SP, Colors.black),)
                    ],
                  ),
                ),
                Container(height: 1.H, color: AppColors.warmGrey2,)
              ],
            ),
          ),
          SizedBox(height: 12.H,),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 49.H,
              decoration: const BoxDecoration(
                color: AppColors.jadeGreen,
                borderRadius: BorderRadius.all(Radius.circular(4))
              ),
              child: Center(
                  child: Text(
                    'Cancel',
                    style: boldTextStyle(16, Colors.white),
                  ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
