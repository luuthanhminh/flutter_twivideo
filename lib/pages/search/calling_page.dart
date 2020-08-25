import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail.dart';
import 'package:flirtbees/pages/history/friend_request_provider.dart';
import 'package:flirtbees/pages/history/history_settings_page.dart';
import 'package:flirtbees/pages/notifications/notification_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/search/personal_camera_bubble.dart';
import 'package:flirtbees/pages/search/pre_searching_page.dart';
import 'package:flirtbees/pages/webrtc/signaling.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flirtbees/widgets/nested_navigator/nested_navigators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({Key key}) : super(key: key);

  static const String tag = 'call_sample';

  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final CallingProvider provider = context.read<CallingProvider>();
      if (provider.state != SignalingState.CallStateConnected || provider.state == null) {
        debugPrint('Init state Calling page');
        context.read<NotificationProvider>().setContext(context);
        context.read<NotificationProvider>().clientId =
        (provider.currentCaller != null)
            ? provider.currentCaller.uid
            : provider.currentClient.uid;
        await provider.initializeRenderer();
        if (provider.state == null) {
          await Provider.of<CallingProvider>(context, listen: false)
              .getUserInfo();
        }
      }

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getNext() async {
    context.read<CallingProvider>().closeSignal();
    context.read<AppLoadingProvider>().showLoading(context);
    await context.read<CallingProvider>().getRandom();
    context.read<AppLoadingProvider>().hideLoading();
  }

  Future<void> didTapFriendRequest() async {
    final Friend friend = context.read<CallingProvider>().currentFriend;
    if (friend.isFullFriend) {
      Fluttertoast.showToast(
          msg: 'You already friend with ${friend.user.name}');
    } else {
      if (friend.isRequestFriend) {
        Fluttertoast.showToast(msg: 'Already requested');
      } else {
        context.read<AppLoadingProvider>().showLoading(context);
        User user = context.read<CallingProvider>().currentCaller;
        user ??= context.read<CallingProvider>().currentClient;
        context.read<FriendRequestProvider>().currentFriend =
            AppHelper.convertUserToFriend(user: user);
        final bool isSuccess = await context
            .read<CallingProvider>()
            .requestFriend(friendId: user.uid);
        friend.isRequestFriend = isSuccess;
        context.read<CallingProvider>().updateFriendStatus(friend);
        context.read<AppLoadingProvider>().hideLoading();
      }
    }
  }

  void handleLogout() {
    if (Provider.of<CallingProvider>(context, listen: false).signaling !=
        null) {
      Provider.of<CallingProvider>(context, listen: false).closeSignal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paleGrey,
      body: Stack(
        children: <Widget>[
          const ImageBackgroundWidget(
            imageAsset: AppImages.background,
          ),
          Consumer<CallingProvider>(
              builder: (BuildContext context, CallingProvider provider, _) {
            return SingleChildScrollView(
              child: Container(
                height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          color: Colors.black,
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 5.W),
                                width: 30.W,
                                height: 30.H,
                                child: InkWell(
                                  onTap: () {
                                    // ignore: always_specify_types
                                    Navigator.popUntil(context,
                                        (Route route) => route.isFirst);
                                    NestedNavigatorsBlocProvider.of(context)
                                        .setTabBarVisibility(true);
                                    if (Provider.of<CallingProvider>(context,
                                                listen: false)
                                            .signaling !=
                                        null) {
                                      Provider.of<CallingProvider>(context,
                                              listen: false)
                                          .closeSignal();
                                    }
                                    Provider.of<CallingProvider>(context,
                                            listen: false)
                                        .clearData();
                                    context
                                        .read<NotificationProvider>()
                                        .disposeCurrentContext();
                                  },
                                  child: Image.asset(
                                    AppImages.icBack,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 366.H,
                          color: Colors.black,
                          child: Center(
                            child: (provider.state ==
                                        SignalingState.CallStateConnected ||
                                    provider.state ==
                                        SignalingState.CallStateRequest ||
                                    provider.state ==
                                        SignalingState.CallStateNew ||
                                    provider.state ==
                                        SignalingState.CallStateRinging)
                                ? Stack(
                                    // ignore: always_specify_types
                                    children: [
                                      Column(
                                        children: <Widget>[
                                          SizedBox(height: 9.H),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0.W, right: 15.0.W),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.popUntil(
                                                        context,
                                                        (Route route) =>
                                                            route.isFirst);
                                                    NestedNavigatorsBlocProvider
                                                            .of(context)
                                                        .selectAndNavigate(
                                                            AppConstant
                                                                .messagePageRoute,
                                                            (NavigatorState
                                                                    navigator) =>
                                                                navigator.pushNamed(
                                                                    AppConstant
                                                                        .messagePageRoute,
                                                                    arguments:
                                                                        true));
                                                  },
                                                  child: Image.asset(AppImages
                                                      .icMessageWhiteSolid),
                                                ),
                                                Text(
                                                    provider.currentFriend?.user
                                                            ?.name ??
                                                        '',
                                                    style: normalTextStyle(
                                                        16.SP, Colors.white)),
                                                GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet<
                                                              HistorySettingsPage>(
                                                          context: context,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          isScrollControlled:
                                                              true,
                                                          useRootNavigator:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return HistorySettingsPage();
                                                          });
                                                    },
                                                    child: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.white))
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 21.H),
                                          Container(
                                              height: 219.H,
                                              width: ScreenUtil.screenWidthDp,
                                              child: (provider.state ==
                                                      SignalingState
                                                          .CallStateConnected)
                                                  ? CameraSizedPreviewBox(
                                                      boxFit: BoxFit.fitWidth,
                                                      cameraRatio: 4 / 6,
                                                      margin: EdgeInsets.zero,
                                                      cameraPreview:
                                                          RTCVideoView(provider
                                                              .remoteRenderer))
                                                  : Container(
                                                      color: AppColors.black,
                                                      child: const Center(
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      ))),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      InkWell(
                                                          onTap: () {
                                                            handleLogout();
                                                          },
                                                          child: Text(
                                                              'Sign out',
                                                              style: normalTextStyle(
                                                                  16.SP,
                                                                  Colors
                                                                      .white))),
                                                      InkWell(
                                                          onTap: () {
                                                            provider
                                                                .setShownGiftView();
                                                          },
                                                          child: Image.asset(
                                                              AppImages
                                                                  .icGift)),
                                                      InkWell(
                                                        onTap: () async {
                                                          didTapFriendRequest();
                                                        },
                                                        child: Image.asset(
                                                          AppImages
                                                              .icAddUserOutline,
                                                          color: ((context
                                                                          .watch<
                                                                              CallingProvider>()
                                                                          .currentFriend
                                                                          ?.isRequestFriend ??
                                                                      false) ||
                                                                  (context
                                                                          .watch<
                                                                              CallingProvider>()
                                                                          .currentFriend
                                                                          ?.isFullFriend ??
                                                                      false))
                                                              ? AppColors
                                                                  .jadeGreen
                                                              : AppColors.white,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          await getNext();
                                                        },
                                                        child: Text('Next',
                                                            style:
                                                                normalTextStyle(
                                                                    16.SP,
                                                                    Colors
                                                                        .white)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20.H),
                                        ],
                                      ),
                                      Positioned(
                                        bottom: 50.H,
                                        child: (provider.isShownGiftView)
                                            ? Container(
                                                height: 99.H,
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.19),
                                                          offset: const Offset(
                                                              0, 2),
                                                          blurRadius: 4)
                                                    ]),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: provider
                                                        .messageGifts.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final MessageGift gift =
                                                          provider.messageGifts[
                                                              index];
                                                      return MessageGift(
                                                        giftName: gift.giftName,
                                                        minutes: gift.minutes,
                                                      );
                                                    }),
                                              )
                                            : Container(),
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      if (Provider.of<CallingProvider>(context)
                                              .currentFriend?.user?.
                                              avatar !=
                                          null)
                                        Container(
                                            width: 97.W,
                                            height: 97.W,
                                            decoration: BoxDecoration(
                                                color: AppColors.white3,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        AppHelper.getImageUrl(
                                                            imageName: Provider
                                                                    .of<CallingProvider>(
                                                                        context)
                                                                .currentFriend
                                                                ?.user
                                                                ?.avatar)),
                                                    fit: BoxFit.cover)))
                                      else
                                        Container(
                                          width: 97.W,
                                          height: 97.W,
                                        ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 16.0.H, bottom: 16.0.H),
                                        child: Text(
                                            Provider.of<CallingProvider>(context).currentFriend?.user?.name,
                                            style: normalTextStyle(
                                                18.SP, Colors.white),
                                      )),
                                      if (provider.currentClient != null) Container(
                                        height: 49.H,
                                        margin: EdgeInsets.only(bottom: 12.H),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.H),
                                        child: RaisedButton(
                                          color: AppColors.jadeGreen,
                                          onPressed: provider
                                                      .currentClient?.uid ==
                                                  null
                                              ? null
                                              : () {
                                                  provider.inviteToCalling(
                                                      peerId: provider
                                                          .currentClient?.uid,
                                                      buildContext: context);
                                                },
                                          padding: EdgeInsets.only(
                                              left: 32.0.W, right: 32.0.W),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(
                                                Icons.call,
                                                color: Colors.white,
                                                size: 16.0.H,
                                              ),
                                              SizedBox(width: 8.W),
                                              Text(
                                                'Start call',
                                                style: boldTextStyle(
                                                    16.SP, Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ) else Container()
                                    ],
                                  ),
                          ),
                        ),
                        if (context
                            .watch<CallingProvider>()
                            .messages
                            .isNotEmpty)
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: context
                                  .watch<CallingProvider>()
                                  .messages
                                  .length,
                              reverse: true,
                              padding: EdgeInsets.only(bottom: 63.H),
                              itemBuilder: (BuildContext context, int index) {
                                return CallMessageItem(
                                    message: context
                                        .read<CallingProvider>()
                                        .messages[index]
                                        .message,
                                    isReceive: context
                                        .read<CallingProvider>()
                                        .messages[index]
                                        .isReceive);
                              },
                            ),
                          )
                        else
                          Expanded(child: Container()),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        color: Colors.white,
                        height: 57.H,
                        padding: EdgeInsets.only(left: 15.W, right: 15.W),
                        child: Row(
                          children: <Widget>[
                            Image.asset(AppImages.icTranslate),
                            SizedBox(width: 9.W),
                            Flexible(
                              child: TextField(
                                onChanged: (String text) {
                                  Provider.of<CallingProvider>(context,
                                          listen: false)
                                      .currentMessage = text;
                                },
                                controller: TextEditingController()
                                  ..text = Provider.of<CallingProvider>(context)
                                      .currentMessage,
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Type in a text…',
                                    hintStyle: normalTextStyle(
                                        16.SP, AppColors.coolGrey)),
                              ),
                            ),
                            InkWell(
                                onTap: () async {
                                  Provider.of<CallingProvider>(context,
                                          listen: false)
                                      .sendMessage(
                                          peerId: (provider.currentCaller !=
                                                  null)
                                              ? provider.currentCaller?.uid
                                              : provider.currentClient?.uid, inCalling: true);
                                },
                                child: Image.asset(AppImages.icSend)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          PersonalCameraBubble(),
        ],
      ),
    );
  }
}

class CallMessageItem extends StatelessWidget {
  const CallMessageItem({Key key, this.id, this.message, this.isReceive})
      : super(key: key);
  final String id;
  final String message;
  final bool isReceive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isReceive ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.H, left: 10.W, right: 10.W),
          padding: EdgeInsets.all(11.W),
          decoration: BoxDecoration(
              color: isReceive ? AppColors.eggShell : AppColors.paleGreyThree,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(color: AppColors.sunflowerYellow)),
          child: Text(message,
              style: normalTextStyle(12.SP, AppColors.greyishBrown)),
        ),
      ],
    );
  }
}
