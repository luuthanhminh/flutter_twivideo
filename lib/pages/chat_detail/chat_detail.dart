import 'package:flirtbees/models/remote/message.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail_provider.dart';
import 'package:flirtbees/pages/history/friend_request_provider.dart';
import 'package:flirtbees/pages/messages/messages_page.dart';
import 'package:flirtbees/pages/messages/messages_provider.dart';
import 'package:flirtbees/pages/notifications/notification_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/socket_helper.dart';
import 'package:flirtbees/widgets/nested_navigator/nested_navigators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flirtbees/utils/utils.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('Chat detail route name: ${ModalRoute.of(context)?.settings?.name}');
      context.read<NotificationProvider>().setContext(context);
      context.read<NotificationProvider>().clientId = context.read<ChatDetailProvider>().friend.uid;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getMoreMessages();
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      debugPrint('Reach bottom');
    }
  }

  Future<void> getMoreMessages() async {
    if (context.read<ChatDetailProvider>().messagesList.length >= context.read<ChatDetailProvider>().minIndexMessage) {
      debugPrint('Get more message from ${context.read<ChatDetailProvider>().minIndexMessage}');
      final List<Message> messageList = await context.read<ChatDetailProvider>().getListMessage(from: context.read<ChatDetailProvider>().minIndexMessage + 1, to: context.read<ChatDetailProvider>().minIndexMessage + 50);
      await context.read<ChatDetailProvider>().setMessageList(messages: messageList);
    }
  }

  Future<void> handlePressFavourite() async {
    final String friendId = context.read<ChatDetailProvider>().friend.uid;
    context.read<AppLoadingProvider>().showLoading(context);
    if (!context.read<ChatDetailProvider>().friend.isFavorite) {
      bool _ = await context.read<FriendRequestProvider>().favouriteFriend(friendId: friendId);
      context.read<ChatDetailProvider>().setFavored(true);
      context.read<AppLoadingProvider>().hideLoading();
      context.read<MessagesProvider>().getListFriends();
    } else {
      bool _ = await context.read<FriendRequestProvider>().deleteFavouriteFriend(friendId: friendId);
      context.read<ChatDetailProvider>().setFavored(false);
      context.read<AppLoadingProvider>().hideLoading();
      context.read<MessagesProvider>().getListFriends();
    }
  }

  void onTapBack() {
    final Friend currentFriend = context.read<ChatDetailProvider>().friend;
    final List<MessageSlot> listFriend = context.read<MessagesProvider>().allMessages;
    for (int i = 0; i < listFriend.length; i++) {
      if (listFriend[i].friend.uid == currentFriend.uid) {
        listFriend[i].friend.lastMessage.bodyMessage.value = context.read<ChatDetailProvider>().messagesList.first.bodyMessage.value;
        listFriend[i].friend.lastMessage.createdAt = context.read<ChatDetailProvider>().messagesList.first.createdAt;
        break;
      }
    }
    context.read<MessagesProvider>().updateFriendMessageList(list: listFriend);

    context.read<NotificationProvider>().disposeCurrentContext();
    NestedNavigatorsBlocProvider.of(context).setTabBarVisibility(true);
    Navigator.pop(context);
  }

  String getFriendSocketStatus() {
    final String id = context.read<ChatDetailProvider>().friend.uid;
    if (Provider.of<SocketHelper>(context).friendOnlines[id] != null) {
      return 'Online';
    }
    return 'Offline';
  }

  Color getColorFriendSocketStatus() {
    final String id = context.read<ChatDetailProvider>().friend.uid;
    if (Provider.of<SocketHelper>(context).friendOnlines[id] != null) {
      return AppColors.jadeGreen;
    }
    return AppColors.steel;
  }

  @override
  Widget build(BuildContext context) {
//    NestedNavigatorsBlocProvider.of(context).setTabBarVisibility(false);
    return Consumer<ChatDetailProvider>(
        builder: (BuildContext context, ChatDetailProvider provider, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: AppColors.tabBarColor,
                  height: 60.H,
                  padding: EdgeInsets.only(left: 8.W, right: 14.H),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          onTapBack();
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(AppConstant.profilePicturePageRoute);
                        },
                        child: Container(
                            width: 36.H,
                            height: 36.H,
                            decoration: BoxDecoration(
                                color: AppColors.white3,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(AppHelper.getImageUrl(imageName: context.watch<ChatDetailProvider>().friend?.avatar)),
                                    fit: BoxFit.cover))
                        ),
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
                            Text(context.watch<ChatDetailProvider>().friend.name, style: semiBoldTextStyle(17.SP, Colors.black),),
                            SizedBox(width: 10.W,),
                            InkWell(
                              onTap: () async {
                                await handlePressFavourite();
                              },
                                child: Container(width: 16.W, height: 14.H,child: provider.isFavourite ? Image.asset(AppImages.icHeart) : Image.asset(AppImages.icNounHeart)))
                          ],
                        ),
                        SizedBox(height: 2.H,),
                        Text(getFriendSocketStatus(), style: normalTextStyle(10.SP, getColorFriendSocketStatus()),)
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(height: 0.5.H, color: AppColors.black30,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: context.watch<ChatDetailProvider>().messagesList.length,
                reverse: true,
                padding: EdgeInsets.only(bottom: 8.H),
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  final Message message = context.watch<ChatDetailProvider>().messagesList[index];
                  if (message.messageType == AppMessageType.send) {
                    return MessageSendItem(message: message);
                  } else {
                    return MessageReceivedItem(message: message);
                  }
                }
              ),
            ),
            Column(
              children: <Widget>[
                if (context.watch<ChatDetailProvider>().isShownGiftView) Container(
                  height: 99.H,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.19), offset: const Offset(0, 2), blurRadius: 4)]
                  ),
                  child: Consumer<ChatDetailProvider>(
                    builder: (BuildContext context, ChatDetailProvider provider, _) {
                      return ListView.builder(
                          shrinkWrap: true,
                        itemCount: provider.messageGifts.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            final MessageGift gift = provider.messageGifts[index];
                            return MessageGift(giftName: gift.giftName, minutes: gift.minutes,);
                          });
                    }
                  ),
                ) else Container(),
                Container(
                  color: AppColors.whiteF6,
                  height: 70.H,
                  child: Container(
                    margin: EdgeInsets.only(left: 26.W, right: 15.W),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 14.4.W,
                          height: 16.H,
                          child: InkWell(
                            onTap: () {
                            },
                            child: Image.asset(AppImages.icSendFile),
                          ),
                        ),
                        SizedBox(width: 19.W,),
                        Container(
                          height: 24.H,
                          width: 30.W,
                          child: InkWell(
                            onTap: () {

                            },
                            child: Image.asset(AppImages.icTranslate),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (String text) {
                              Provider.of<CallingProvider>(context, listen: false).currentMessage = text;
                            },
                            controller: TextEditingController()..text = Provider.of<CallingProvider>(context).currentMessage,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) {
                              Provider.of<CallingProvider>(context, listen: false).sendMessage(peerId: provider.friend.uid, inCalling: false);
                            },
                            decoration: InputDecoration(
                              hintStyle: normalTextStyle(16.SP, AppColors.coolGrey),
                              hintText: 'Type in a text…',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10.W),
                            ),
                          ),
                        ),
                        Container(
                          width: 15.W,
                          height: 16.H,
                          child: InkWell(
                            onTap: () {
                              context.read<ChatDetailProvider>().setShownGiftView();
                            },
                            child: Image.asset(AppImages.icGiftPink, color:  context.watch<ChatDetailProvider>().isShownGiftView ? AppColors.jadeGreen : AppColors.darkGreyBlue,),
                          ),
                        ),
                        SizedBox(width: 20.W,),
                        Container(
                          height: 36.H,
                          width: 36.W,
                          child: InkWell(
                            onTap: () {
                              Provider.of<CallingProvider>(context, listen: false).sendMessage(peerId: provider.friend.uid, inCalling: false);
                            },
                            child: Image.asset(AppImages.icSend),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      }
    );
  }
}

class MessageReceivedItem extends StatelessWidget {
  const MessageReceivedItem({Key key, this.message}) : super(key: key);
  final Message message;


  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.W),
      child: Column(
        children: [
          if (message.isLastMessageInDay) Container(
            margin: EdgeInsets.only(top: 10.H),
            child: Center(
            child: Text(AppHelper.getDateTimeStringFormatWeekDay(message.createdAt), style: boldTextStyle(10.SP, AppColors.blueGrey),),),
          ) else Container(),
          Container(
            margin: EdgeInsets.only(top: 16.H),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 8.W,
                  height: 7.H,
                  child: Image.asset(AppImages.icTriangleLeft),
                ),
                Flexible(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.paleGreyTwo,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4), bottomRight: Radius.circular(4))
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.W, vertical: 8.H),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(child: Text(message.bodyMessage.value, style: normalTextStyle(16.SP, Colors.black),)),
                          ],
                        ),
                        SizedBox(height: 2.H,),
//                        Row(
//                          mainAxisSize: MainAxisSize.min,
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          children: <Widget>[
//                            Flexible(
//                              child: Text('This is subtitle', style: normalTextStyle(10.SP, AppColors.blueGrey),),
//                            )
//                          ],
//                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageSendItem extends StatelessWidget {
  const MessageSendItem({Key key, this.message}) : super(key: key);
  final Message message;


  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.W),
      child: Column(
        children: [
          if (message.isLastMessageInDay) Container(
            margin: EdgeInsets.only(top: 10.H),
            child: Center(
              child: Text(AppHelper.getDateTimeStringFormatWeekDay(message.createdAt), style: boldTextStyle(10.SP, AppColors.blueGrey),),),
          ) else Container(),
          Container(
            margin: EdgeInsets.only(top: 16.H),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: AppColors.paleGreyThree,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4), bottomLeft: Radius.circular(4))
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.W, vertical: 8.H),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Text(message.bodyMessage.value, style: normalTextStyle(16.SP, Colors.black),),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.H,),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          mainAxisSize: MainAxisSize.min,
//                          children: <Widget>[
//                            Flexible(child: Text('This is subtitle', style: normalTextStyle(10.SP, AppColors.blueGrey),)),
//                          ],
//                        ),
                        SizedBox(height: 8.H,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(AppHelper.getDateTimeStringFormatHHmm(message.createdAt), style: boldTextStyle(10.SP, AppColors.blueGrey),),
                            SizedBox(width: 9.W,),
                            Container(
                              width: 10.W,
                              height: 7.H,
                              child: Image.asset(AppImages.icMessageSent),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 8.W,
                  height: 7.H,
                  child: Image.asset(AppImages.icTriangleRight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageGift extends StatelessWidget {
  const MessageGift({Key key, this.giftName, this.minutes}) : super(key: key);

  final String giftName;
  final int minutes;

  String getGiftImage() {
    switch (giftName) {
      case 'diamond':
        return AppImages.diamond;
      case 'flower':
        return AppImages.flower;
      case 'catGift':
        return AppImages.catGift;
      case 'strawberry':
        return AppImages.strawberry;
      case 'tsar':
        return AppImages.tsar;
        default:
          return null;
          break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.W,
      padding: EdgeInsets.symmetric(vertical: 18.H),
      child: Column(
        children: <Widget>[
          Container(
            height: 38.H,
            child: Image.asset(getGiftImage()),
          ),
          SizedBox(height: 9.H),
          Text('- $minutes min', style: normalTextStyle(10.SP, AppColors.steel),)
        ],
      ),
    );
  }

}

