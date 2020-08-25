import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/app_constant.dart';
import 'package:flirtbees/utils/app_style.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flirtbees/utils/utils.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const ColorBackgroundWidget(
          color: Color(0xFFE8E3E8),
        ),
        Container(
          color: const Color(0xFFE8E3E8).withOpacity(0.3),
          child: Column(
            children: <Widget>[
              WelcomeHeader(),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.screenWidthDp,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      child: Image.asset(AppImages.image1, fit: BoxFit.cover),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 2),
                            child: Image.asset(AppImages.image2,
                                fit: BoxFit.cover),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 2, right: 16),
                            child: Image.asset(AppImages.image2,
                                fit: BoxFit.cover),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Want to find girls to chat to?',
                      style: normalTextStyle(18, const Color(0xFF1F1F1F)),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 49,
                      width: ScreenUtil.screenWidthDp,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RaisedButton(
                        color: AppColors.jadeGreen,
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppConstant.genderSelectPageRoute);
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          'Start video chat',
                          style: boldTextStyle(16, Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 23),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(AppImages.icRecord, width: 17),
                        const SizedBox(width: 5),
                        Text(
                          'Activate your camera to start searching',
                          style: normalTextStyle(14, AppColors.warmGrey),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        )
      ],
    );
  }
}

class WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            spreadRadius: -5,
            blurRadius: 3,
            offset: Offset(0.0, 7),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 100,
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  child: RaisedButton(
                    onPressed: () {},
                    color: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: Image.asset(
                      AppImages.icEmail,
                      width: 24,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  child: RaisedButton(
                    onPressed: () {},
                    color: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: Image.asset(
                      AppImages.icFlag,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            alignment: Alignment.center,
            child: Image.asset(AppImages.icFlirtbeesLogo),
          ),
          Container(
            width: 100,
            margin: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: Image.asset(AppImages.icFlirtbeesIcon),
          ),
        ],
      ),
    );
  }
}
