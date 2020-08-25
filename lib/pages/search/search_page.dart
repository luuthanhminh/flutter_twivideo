
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/login/login_page.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/pages/register/register_page.dart';
import 'package:flirtbees/pages/search/pre_searching_popup.dart';
import 'package:flirtbees/pages/search/search_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'calling_provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              image: DecorationImage(image: AssetImage(AppImages.image3), fit: BoxFit.cover),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (context.watch<LoginProvider>().isLoggedIn)
                Container(
                  width: ScreenUtil.screenWidthDp,
                  margin: EdgeInsets.only(top: 15.H, left: 15.W, right: 15.W),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.white
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0.W),
                            child: Image.asset(AppImages.icMaleAvatar, height: 34.W, width: 34.W),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Jacob', style: normalTextStyle(14.SP, Colors.black)),
                                SizedBox(height: 2.H),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(3.W),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(3)),
                                          color: AppColors.darkGreyBlue
                                      ),
                                      child: Text('Premium', style: boldTextStyle(10.SP, Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 2.W,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3.W),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.jadeGreen
                                      ),
                                      child: Icon(Icons.add, color: Colors.white, size: 10.SP,),
                                    ),
                                    SizedBox(
                                      width: 8.W,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3.W),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(3)),
                                          color: AppColors.lipstick
                                      ),
                                      child: Text('Minutes low', style: boldTextStyle(10.SP, Colors.white)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context.read<SearchProvider>().toggleExpanding();
                            },
                            child: Container(
                                width: 48.W,
                                child: Image.asset(context.watch<SearchProvider>().isResultExpanding ? AppImages.icArrowUp : AppImages.icArrowDown)),
                          )
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: context.watch<SearchProvider>().isResultExpanding ? 110.H : 0,
                        padding: EdgeInsets.all(8.0.W),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                            color: Color(0xffEAF3F7)
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Premium status', style: normalTextStyle(14.SP, Colors.black)),
                                  Text('03/08/2020', style: normalTextStyle(14.SP, AppColors.steel)),
                                ],
                              ),
                              SizedBox(
                                height: 8.H,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(8.W),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                          color: Colors.white
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('56', style: normalTextStyle(27.SP, Colors.black)),
                                                  Image.asset(AppImages.icMessageSmall)
                                                ],
                                              ),
                                              Text('Messages left', style: normalTextStyle(17.SP, Colors.black)),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(3.W),
                                            width: 15.W,
                                            height: 15.H,
                                            margin: EdgeInsets.only(right: 2.W),
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.jadeGreen
                                            ),
                                            child: Center(child: Text('i', style: normalTextStyle(10.SP, AppColors.white),)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.W,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(AppConstant.purchasePageRoute);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.W),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                            color: Colors.white
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text('1', style: normalTextStyle(27.SP, AppColors.lipstick)),
                                                    Image.asset(AppImages.icClock)
                                                  ],
                                                ),
                                                Text('Minutes left', style: normalTextStyle(17.SP, Colors.black)),
                                              ],
                                            ),
                                            Container(
                                              width: 15.W,
                                              height: 15.H,
                                              padding: EdgeInsets.all(3.W),
                                              margin: EdgeInsets.only(right: 2.W),
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.jadeGreen
                                              ),
                                              child: Center(child: Icon(Icons.add, color: Colors.white, size: 10.SP,)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              else if (context.watch<LoginProvider>().isLoggedIn) Container()
              else Container(
                  height: 49.H,
                  width: ScreenUtil.screenWidthDp,
                  margin: EdgeInsets.only(top: 10.H),
                  padding: EdgeInsets.symmetric(horizontal: 16.H),
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: () {

                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Text.rich(
                        TextSpan(
                            text: 'Register',
                            recognizer: TapGestureRecognizer()..onTap = () => showCupertinoModalBottomSheet<dynamic>(
                                expand: true,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context, ScrollController scrollController) =>
                                    RegisterPage()
                            ),
                            style: boldTextStyle(19.SP, AppColors.darkGreyBlue),
                            children: <TextSpan> [
                              TextSpan(text: ' or ',
                                style: boldTextStyle(19.SP, AppColors.steel)
                              ),
                              TextSpan(text: 'Sign in',
                                style: boldTextStyle(19.SP, AppColors.darkGreyBlue),
                                recognizer: TapGestureRecognizer()..onTap = () => showCupertinoModalBottomSheet<dynamic>(
                                  expand: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context, ScrollController scrollController) =>
                                      LoginPage()
                                )
                              ),
                            ]
                        )
                    ),
                  ),
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Consumer<SearchProvider>(
                      builder: (BuildContext context, SearchProvider provider, _) {
                        if (provider.isTimerRunning) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 50.W, right: 50.W, bottom: 8.H),
                                child: Text('Sign in or wait',
                                  style: normalTextStyle(18.SP, Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List<Widget>.generate(4, (int index) {
                                    final double leftSpace = index == 2 ? 3.0.W : 0;
                                    final double rightSpace = index == 1 ? 3.0.W : 0;
                                    final Duration currentTimer = Duration(seconds: provider.countDownTime);
                                    final int minutes = currentTimer.inMinutes;
                                    final int seconds = currentTimer.inSeconds % 60;
                                    final String currentTimeIn4LengthString = "${minutes < 10 ? "0$minutes" : minutes}${seconds < 10 ? "0$seconds" : seconds}";
                                    return Container(
                                      height: 40.H,
                                      margin: EdgeInsets.only(left: 2.0.W + leftSpace, right: 2.0.W + rightSpace, bottom: 18.H),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(2.0.W))
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 0.5,
                                        child: Center(child: Text(currentTimeIn4LengthString[index],
                                          style: boldTextStyle(16.SP, Colors.black),
                                        )),
                                      ),
                                    );
                                  }),
                                ),
                              )
                            ],
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(left: 50.W, right: 50.W, bottom: 18.H),
                          child: Text('Want to find someone to chat with?',
                            style: blackTextStyle(20.SP, Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                  ),
                  Container(
                    height: 49.H,
                    width: ScreenUtil.screenWidthDp,
                    margin: EdgeInsets.only(bottom: 10.H),
                    padding: EdgeInsets.symmetric(horizontal: 16.H),
                    child: RaisedButton(
                      color: AppColors.jadeGreen,
                      onPressed: () async {
                        if (!context.read<LoginProvider>().isLoggedIn) {
                          if (await context.read<LocalStorage>().isGuestUser()) {
                            if (!context.read<SearchProvider>().isTimerRunning) {
                              context.read<SearchProvider>().startTimer();
                            }
                            Navigator.pushNamed(context, AppConstant.preSearchingPageRoute);
                            return;
                          }
                          context.read<AppLoadingProvider>().showLoading(context);
                          await context.read<SearchProvider>().requestGuestToken(callback: (bool isSuccess, String msg, User user) {
                            if (isSuccess) {
                              context.read<CallingProvider>().connect(context);
                              context.read<SearchProvider>().startTimer();
                            }
                          });
                          context.read<AppLoadingProvider>().hideLoading();
                          return;
                        }
                        if (await context.read<SearchProvider>().isAllPermissionsGranted()) {
                          Navigator.pushNamed(context, AppConstant.preSearchingPageRoute);
                          return;
                        }
                        final SearchProvider searchProvider = context.read<SearchProvider>();
                        showModalBottomSheet<String>(
                            context: context,
                            useRootNavigator: true,
                            isScrollControlled: true,
                            builder: (BuildContext context) => ChangeNotifierProvider<SearchProvider>.value(
                                value: searchProvider,
                                child: PreSearchingPopup())).then((dynamic value) async {
                                  if (value == 'true') {
                                    Navigator.pushNamed(context, AppConstant.preSearchingPageRoute);
                                  }
                        });
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text(
                        'Start search',
                        style: boldTextStyle(19.SP, Colors.white),
                      ),
                    ),
                  )
                ],
              ),

            ],
          )
        ],
      ),
    );
  }
}
