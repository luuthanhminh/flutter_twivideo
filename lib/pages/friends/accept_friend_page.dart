import 'package:flirtbees/pages/friends/accept_friend_provider.dart';
import 'package:flirtbees/pages/messages/messages_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/app_color.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nested_navigators/nested_nav_bloc_provider.dart';
import 'package:provider/provider.dart';

class AcceptFriendPage extends StatefulWidget {
  @override
  _AcceptFriendPageState createState() => _AcceptFriendPageState();
}

class _AcceptFriendPageState extends State<AcceptFriendPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const ImageBackgroundWidget(
          imageAsset: AppImages.background,
        ),
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 60.H,
                  color: AppColors.tabBarColor,
                  padding: EdgeInsets.only(left: 8.W, right: 14.H),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          NestedNavigatorsBlocProvider.of(context).setTabBarVisibility(true);
                        },
                        child: Container(
                          width: 30.W,
                          height: 30.H,
                          child: Container(
                            width: 10.W,
                            height: 20.H,
                            child: Image.asset(AppImages.icBack, color: AppColors.darkGreyBlue,),
                          ),
                        ),
                      ),
                      Container(
                          width: 36.H,
                          height: 36.H,
                          decoration: BoxDecoration(
                              color: AppColors.white3,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(AppHelper.getImageUrl(imageName: Provider.of<AccpetFriendProvider>(context).friend?.avatar)),
                                  fit: BoxFit.cover))
                      ),

                    ],
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 15.H),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(context.watch<AccpetFriendProvider>().friend?.name, style: semiBoldTextStyle(17.SP, Colors.black),),
                            SizedBox(width: 10.W,),
                            Container(width: 16.W, height: 14.H,child: Image.asset(AppImages.icHeart))
                          ],
                        ),
                        SizedBox(height: 2.H,),
                        Text('Online', style: normalTextStyle(10.SP, AppColors.steel),)
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(height: 0.5.H, color: AppColors.black30,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 174.H,
                      height: 174.H,
                      decoration: BoxDecoration(
                          color: AppColors.white3,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(AppHelper.getImageUrl(imageName: Provider.of<AccpetFriendProvider>(context).friend?.avatar)),
                              fit: BoxFit.cover))
                  ),
                  SizedBox(height: 24.H),
                  Text(context.watch<AccpetFriendProvider>().friend?.name, style: normalTextStyle(18.SP, Colors.black)),
                  SizedBox(height: 8.H),
                  Text('Want to add you as a friend', style: normalTextStyle(16.SP, Colors.black)),
                  SizedBox(height: 20.H),
                  Container(
                    height: 49.H,
                    width: ScreenUtil.screenWidthDp,
                    margin: EdgeInsets.only(bottom: 10.H),
                    padding: EdgeInsets.symmetric(horizontal: 16.H),
                    child: RaisedButton(
                      color: AppColors.jadeGreen,
                      onPressed: () async {
                        context.read<AppLoadingProvider>().showLoading(context);
                        final bool result = await Provider.of<AccpetFriendProvider>(context, listen: false).acceptFriend();
                        context.read<AppLoadingProvider>().hideLoading();
                        if (result) {
                          Fluttertoast.showToast(msg: 'Accepted friend!');
                          context.read<MessagesProvider>().getListFriends();
                          Navigator.pop(context);
                          NestedNavigatorsBlocProvider.of(context).setTabBarVisibility(true);
                        }
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text(
                        'Accept',
                        style: boldTextStyle(16.SP, Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.H,),
                  Container(
                    height: 49.H,
                    width: ScreenUtil.screenWidthDp,
                    margin: EdgeInsets.only(bottom: 10.H),
                    padding: EdgeInsets.symmetric(horizontal: 16.H),
                    child: RaisedButton(
                      color: AppColors.fireEngineRed,
                      onPressed: () async {
                        context.read<AppLoadingProvider>().showLoading(context);
                        final bool result = await Provider.of<AccpetFriendProvider>(context, listen: false).declineFriend();
                        context.read<AppLoadingProvider>().hideLoading();
                        if (result) {
                          Fluttertoast.showToast(msg: 'Declined friend!');
                          context.read<MessagesProvider>().getListFriends();
                          Navigator.pop(context);
                          NestedNavigatorsBlocProvider.of(context).setTabBarVisibility(true);
                        }
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text(
                        'Decline',
                        style: boldTextStyle(16.SP, Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
