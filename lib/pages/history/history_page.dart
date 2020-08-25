import 'package:camera/camera.dart';
import 'package:flirtbees/models/remote/message.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail_provider.dart';
import 'package:flirtbees/pages/history/history_provider.dart';
import 'package:flirtbees/pages/history/history_settings_page.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/search/pre_searching_popup.dart';
import 'package:flirtbees/pages/search/search_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/socket_helper.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/app_header.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flirtbees/widgets/nested_navigator/nested_navigators.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'friend_request_provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NestedNavigatorsBlocProvider.of(context).setTabBarVisibility(true);
    });
  }

  Future<void> getMessages({int from, int to}) async {
    if (context.read<CallingProvider>().messagesList != null) {
      context.read<CallingProvider>().messagesList.clear();
    }
    context.read<AppLoadingProvider>().showLoading(context);
    final List<Message> messageList = await context.read<ChatDetailProvider>().getListMessage(from: from, to: to);
    await context.read<ChatDetailProvider>().setMessageList(messages: messageList);
    context.read<AppLoadingProvider>().hideLoading();
  }

  Future<void> onTapGoToChatRoom() async {
    final Friend friend = context
        .read<HistoryProvider>()
        .historiesList[context
        .read<HistoryProvider>()
        .currentIndex];
    if (friend.isFullFriend) {
      context
          .read<ChatDetailProvider>()
          .friend =
          AppHelper.convertHistoryFriendToFriend(historyFriend: friend);
      context
          .read<ChatDetailProvider>()
          .isFavourite = context
          .read<ChatDetailProvider>()
          .friend
          .isFavorite;
      if (context
          .read<CallingProvider>()
          .messagesList != null) {
        context
            .read<CallingProvider>()
            .messagesList
            .clear();
      }
      await getMessages(from: 0, to: 50);
      Navigator.pushNamed(context, AppConstant.chatDetailPageRoute);
    } else {
      Fluttertoast.showToast(
          msg: 'Please invite ${friend.user.name} become to friend to chat.');
    }
  }

    Future<void> onTapInviteFriend() async {
      final Friend friend = Provider.of<HistoryProvider>(context, listen: false).historiesList[Provider.of<HistoryProvider>(context, listen: false).currentIndex];

      if (friend.isFullFriend) {
        Fluttertoast.showToast(msg: 'You already friend with ${friend.user.name}');
      } else {
        if (friend.isRequestFriend) {
          Fluttertoast.showToast(msg: 'You already invited friend with ${friend.user.name}');
          return;
        }
        Provider.of<FriendRequestProvider>(context, listen: false).currentFriend = AppHelper.convertHistoryFriendToFriend(historyFriend: friend);
        Navigator.pushNamed(context, AppConstant.friendRequestPageRoute);
      }

    }

    Future<void> onTapGoToCalling() async {
      final Friend friend = Provider.of<HistoryProvider>(context, listen: false).historiesList[Provider.of<HistoryProvider>(context, listen: false).currentIndex];
      if (friend.isFullFriend) {
        if (await Provider.of<SearchProvider>(context, listen: false).isAllPermissionsGranted()) {
          final List<CameraDescription> cameras = await availableCameras();
          Provider.of<CallingProvider>(context, listen: false).currentFriend = Provider.of<HistoryProvider>(context, listen: false).historiesList[Provider.of<HistoryProvider>(context, listen: false).currentIndex];
          Provider.of<CallingProvider>(context, listen: false).currentClient = Provider.of<CallingProvider>(context, listen: false).currentFriend.user;
          Navigator.pushNamed(context, AppConstant.searchingPageRoute, arguments: cameras);
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
            final List<CameraDescription> cameras = await availableCameras();
            Navigator.pushNamed(context, AppConstant.searchingPageRoute, arguments: cameras);
          }
        });
      } else {
        Fluttertoast.showToast(msg: 'Please invite ${friend.user.name} become to friend to start video call.');
      }

    }

    bool getOnlineStatus(Friend friend, BuildContext context) {
      // ignore: unnecessary_parenthesis
      debugPrint('Friend ID in history: ${friend.user.uid}');
      // ignore: unnecessary_parenthesis
      return (context.watch<SocketHelper>().friendOnlines[friend.user.uid] != null);
    }


  @override
  Widget build(BuildContext context) {
    if ( Provider.of<LoginProvider>(context).isLoggedIn) {
      return Container(
        color: AppColors.paleGrey,
        child: Stack(
          children: <Widget>[
            const ImageBackgroundWidget(
              imageAsset: AppImages.background,
            ),
            Column(
              children: <Widget>[
                AppHeader(
                  title: 'History',
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        showModalBottomSheet<HistorySettingsPage>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            useRootNavigator: true,
                            builder: (BuildContext context) {
                              return HistorySettingsPage();
                            });
                      },
                        child: Image.asset(AppImages.icMore))
                  ],
                ),
                Expanded(
                  child: (context.watch<HistoryProvider>().historiesList.isNotEmpty) ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 240.H,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.6, initialPage: 0),
                          itemCount: context.watch<HistoryProvider>().historiesList.length,
                          onPageChanged: (int index) {
                            context.read<HistoryProvider>().currentIndex = index;
                          },
                          itemBuilder: (BuildContext context, int position) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10.W, right: 10.W),
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        Container(
                                            width: 174.W,
                                            height: 174.W,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.white, width: 5),
                                                color: AppColors.white3,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(AppHelper.getImageUrl(imageName: context.watch<HistoryProvider>().historiesList[position].user?.avatar)),
                                                    fit: BoxFit.cover))
                                        ),
                                        if (getOnlineStatus(context.watch<HistoryProvider>().historiesList[position], context)) Positioned(
                                          right: 18.W,
                                          bottom: 21.H,
                                          child: Container(
                                            width: 16.W,
                                              height: 16.H,
                                              child: Image.asset(AppImages.icDotOnline)),
                                        ) else Container()
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24.H),
                                Text(context.watch<HistoryProvider>().historiesList[position].user?.name, style: normalTextStyle(18.SP, Colors.black)),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 18.H),
                      if (context.watch<LoginProvider>().isButtonsEnable)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                onTapGoToCalling();
                              },
                              child: Container(
                                  height: 46.W,
                                  width: 46.W,
                                  padding: EdgeInsets.only(left: 13.0.W, right: 13.0.W),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.jadeGreen
                                  ), child: Image.asset(AppImages.icCamera)),
                            ),
                            SizedBox(width: 16.W),
                            InkWell(
                              onTap: () {
                                onTapInviteFriend();
                              },
                              child: Container(
                                  height: 46.W,
                                  width: 46.W,
                                  padding: EdgeInsets.only(left: 13.0.W, right: 13.0.W),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.jadeGreen
                                  ), child: Image.asset(AppImages.icAddUserTransparent)),
                            ),
                            SizedBox(width: 16.W),
                            InkWell(
                              onTap: () async {
                                onTapGoToChatRoom();
                              },
                              child: Container(
                                  height: 46.W,
                                  width: 46.W,
                                  padding: EdgeInsets.only(left: 13.0.W, right: 13.0.W),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.jadeGreen
                                  ), child: Image.asset(AppImages.icMessageWhite)),
                            ),
                          ],
                        ) else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(AppImages.icVideoCallOutline, color: Colors.green),
                            SizedBox(width: 16.W),
                            Image.asset(AppImages.icAddUserSolid, color: Colors.green),
                            SizedBox(width: 16.W),
                            Image.asset(AppImages.icMessageOutline),
                          ],
                        )
                    ],
                  ) : const Center(child: Text('No history'),),
                )
              ],
            ),
          ],
        ),
      );
    }
    return Stack(
      children: <Widget>[
        const ImageBackgroundWidget(
          imageAsset: AppImages.background,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    CircleImage(
                      imageName: AppImages.women1,
                      size: 68,
                    ),
                    CircleImage(
                      imageName: AppImages.women2,
                      size: 68,
                    ),
                  ],
                ),
                Center(
                  child: Stack(
                    children: <Widget>[
                      const CircleImage(
                        imageName: AppImages.women3,
                        size: 116,
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Image.asset(AppImages.icSearchPink, height: 34.W, width: 34.W)
                      ),
                    ],
                  ),
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Start chatting now!', style: normalTextStyle(18.SP, Colors.black)),
                SizedBox(height: 4.H),
                Text('Search for some to chat with', style: normalTextStyle(14.SP, AppColors.warmGrey)),
                SizedBox(height: 16.H),
                Container(
                  height: 49.H,
                  width: ScreenUtil.screenWidthDp,
                  margin: EdgeInsets.only(bottom: 10.H),
                  padding: EdgeInsets.symmetric(horizontal: 16.H),
                  child: RaisedButton(
                    color: AppColors.jadeGreen,
                    onPressed: () {
                      NestedNavigatorsBlocProvider.of(context).select(AppConstant.searchPageRoute);
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Text(
                      'Start search',
                      style: boldTextStyle(16.SP, Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

class CircleImage extends StatelessWidget {
  final String imageName;
  final double size;

  // ignore: sort_constructors_first
  const CircleImage({Key key, this.imageName, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.H,
      width: size.H,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.H),
      ),
      child: ClipOval(child: Image.asset(imageName, fit: BoxFit.fill))
    );
  }
}

