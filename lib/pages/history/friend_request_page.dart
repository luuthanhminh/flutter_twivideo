import 'package:flirtbees/pages/history/friend_request_provider.dart';
import 'package:flirtbees/pages/history/history_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendRequestPage extends StatefulWidget {
  @override
  _FriendRequestState createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequestPage> {

  Future<void> handlePressSendButton() async {
    final String friendId = context.read<FriendRequestProvider>().currentFriend.uid;
    context.read<AppLoadingProvider>().showLoading(context);
    if (!context.read<FriendRequestProvider>().isRequested) {
      bool _ = await context.read<FriendRequestProvider>().sendRequestFriend(friendId: friendId);
      context.read<AppLoadingProvider>().hideLoading();
    } else {
      bool _ = await context.read<FriendRequestProvider>().cancelRequestFriend(friendId: friendId);
      context.read<AppLoadingProvider>().hideLoading();
    }
  }

  Future<void> handlePressFavourite() async {
    final String friendId = context.read<FriendRequestProvider>().currentFriend.uid;
    context.read<AppLoadingProvider>().showLoading(context);
    if (!context.read<FriendRequestProvider>().isFavored) {
      bool _ = await context.read<FriendRequestProvider>().favouriteFriend(friendId: friendId);
      context.read<AppLoadingProvider>().hideLoading();
    } else {
      bool _ = await context.read<FriendRequestProvider>().deleteFavouriteFriend(friendId: friendId);
      context.read<AppLoadingProvider>().hideLoading();
    }
  }

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
                          context.read<FriendRequestProvider>().clearData();
                          Navigator.pop(context);
                          context.read<HistoryProvider>().getListHistories();
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
                                  image: NetworkImage(AppHelper.getImageUrl(imageName: context.watch<FriendRequestProvider>().currentFriend?.avatar)),
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
                            Text(context.watch<FriendRequestProvider>().currentFriend?.name ?? '',
                            style: semiBoldTextStyle(17.SP, Colors.black),),
                            SizedBox(width: 10.W,),
                            InkWell(
                              onTap: () async {
                                await handlePressFavourite();
                              },
                                child: Container(width: 16.W, height: 14.H,child: Image.asset( context.watch<FriendRequestProvider>().isFavored ? AppImages.icHeart : AppImages.icNounHeart)))
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
                              image: NetworkImage(AppHelper.getImageUrl(imageName: context.watch<FriendRequestProvider>().currentFriend?.avatar)),
                              fit: BoxFit.cover))
                  ),
                  SizedBox(height: 24.H),
                  Text(context.watch<FriendRequestProvider>().currentFriend?.name ?? '', style: normalTextStyle(18.SP, Colors.black)),
                  SizedBox(height: 8.H),
                  Text( !context.watch<FriendRequestProvider>().isRequested ? 'Become friend' : 'Friend request sent', style: normalTextStyle(16.SP, Colors.black)),
                  SizedBox(height: 20.H),
                  Container(
                    height: 49.H,
                    width: ScreenUtil.screenWidthDp,
                    margin: EdgeInsets.only(bottom: 10.H),
                    padding: EdgeInsets.symmetric(horizontal: 16.H),
                    child: RaisedButton(
                      color: !context.watch<FriendRequestProvider>().isRequested ? AppColors.jadeGreen : AppColors.fireEngineRed,
                      onPressed: () async {
                        await handlePressSendButton();
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text( !context.watch<FriendRequestProvider>().isRequested ? 'Send Request' :
                      'Cancel request',
                        style: boldTextStyle(16.SP, Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );

  }
}



