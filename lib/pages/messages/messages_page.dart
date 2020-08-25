import 'package:flirtbees/models/remote/message.dart';
import 'package:flirtbees/models/remote/response/friends/friends_list_response.dart';
import 'package:flirtbees/pages/chat_detail/chat_detail_provider.dart';
import 'package:flirtbees/pages/friends/accept_friend_provider.dart';
import 'package:flirtbees/pages/login/login_provider.dart';
import 'package:flirtbees/pages/messages/messages_provider.dart';
import 'package:flirtbees/pages/search/calling_provider.dart';
import 'package:flirtbees/pages/search/camera_bubble.dart';
import 'package:flirtbees/pages/webrtc/signaling.dart';
import 'package:flirtbees/services/app_loading.dart';
import 'package:flirtbees/utils/app_asset.dart';
import 'package:flirtbees/utils/app_style.dart';
import 'package:flirtbees/utils/socket_helper.dart';
import 'package:flirtbees/utils/utils.dart';
import 'package:flirtbees/widgets/app_header.dart';
import 'package:flirtbees/widgets/background_widget.dart';
import 'package:flirtbees/widgets/nested_navigator/nested_navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> handleNavigate(Friend friend, BuildContext context) async {
    if (friend.isRequestFriend != null && friend.isRequestFriend) {
      context.read<AccpetFriendProvider>().friend = friend;
      Navigator.pushNamed(context, AppConstant.acceptFriendRoute);
    } else {
      context.read<ChatDetailProvider>().friend = friend;
      context.read<ChatDetailProvider>().isFavourite = friend.isFavorite;
      await getMessages(from: 0, to: 50);
      Navigator.pushNamed(context, AppConstant.chatDetailPageRoute);
    }
  }

  Future<void> getMessages({int from, int to}) async {
    if (context.read<CallingProvider>().messagesList != null) {
      context.read<CallingProvider>().messagesList.clear();
    }
    context.read<AppLoadingProvider>().showLoading(context);
    final List<Message> messageList = await context
        .read<ChatDetailProvider>()
        .getListMessage(from: from, to: to);
    await context.read<ChatDetailProvider>().setMessageList(messages: messageList);
    context.read<AppLoadingProvider>().hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Consumer<MessagesProvider>(
            builder: (BuildContext context, MessagesProvider provider, _) {
          final List<Widget> listMessagesContent = List<Widget>.generate(
              provider.messageThreads.length, (int index) {
            final bool isSelected = provider.selectedIndexes.contains(index);
            return GestureDetector(
              onTap: () {
                if (provider.isEditing) {
                  return;
                }
                provider.currentSelectedIndex = index;
                handleNavigate(
                    context.read<MessagesProvider>().friendList[
                        context.read<MessagesProvider>().currentSelectedIndex],
                    context);
              },
              child: Row(
                children: <Widget>[
                  if (provider.isEditing)
                    GestureDetector(
                      onTap: () {
                        provider.addSelectedIndexes(index);
                      },
                      child: Container(
                        height: 20.W,
                        width: 20.W,
                        margin: EdgeInsets.all(17.W),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.darkGreyBlue
                                : Colors.transparent,
                            border: Border.all(
                                color: isSelected
                                    ? AppColors.darkGreyBlue
                                    : AppColors.steel)),
                        child: isSelected
                            ? Image.asset(AppImages.icMessageSent,
                                color: AppColors.white)
                            : Container(),
                      ),
                    )
                  else
                    Container(),
                  Flexible(child: provider.messageThreads[index]),
                ],
              ),
            );
          });

          final Widget messagesContainer = Stack(
            // wrap cho nay
            children: <Widget>[
              if (provider.isEditing)
                ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 54.H),
                    children: listMessagesContent)
              else
                Column(children: listMessagesContent),
              if (provider.isEditing)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10.H),
                    color: AppColors.paleGrey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 16.0.H,
                          bottom: MediaQuery.of(context).padding.bottom + 22.H),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('Read all',
                              style: normalTextStyle(
                                  17.SP, AppColors.darkGreyBlue)),
                          Text(
                              'Clear${provider.isSelecting ? ' (${provider.selectedIndexes.length})' : ''}',
                              style: normalTextStyle(
                                  17.SP,
                                  provider.isSelecting
                                      ? AppColors.lipstick
                                      : AppColors.steel)),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Container()
            ],
          );
          final Widget content = Container(
              color: AppColors.white,
              child: Stack(
                children: <Widget>[
                  const ImageBackgroundWidget(
                    imageAsset: AppImages.background,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppHeader(
                        leading: context.watch<LoginProvider>().isLoggedIn
                            ? InkWell(
                                onTap: () {
                                  provider.toggleEditing();
                                  NestedNavigatorsBlocProvider.of(context)
                                      .setTabBarVisibility(!provider.isEditing);
                                  provider.setExpand(true);
                                },
                                child: Text(
                                    provider.isEditing ? 'Done' : 'Edit',
                                    style: normalTextStyle(
                                        17.SP, AppColors.darkGreyBlue)))
                            : Text('',
                                style: normalTextStyle(
                                    17.SP, AppColors.darkGreyBlue)),
                        title: 'Messages',
                        isEnableSearching: true,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          provider.toggleExpand();
                        },
                        child: MessageCategory(
                          title: 'Recent conversations',
                          trailing: Image.asset(provider.isExpanded
                              ? AppImages.icArrowDown
                              : AppImages.icArrowUp),
                          titleColor: AppColors.darkGreyBlue,
                          notPaddingLine: provider.isExpanded,
                        ),
                      ),
                      if (!provider.isExpanded || provider.isEditing)
                        Container()
                      else
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.W,
                                  right: 33.W,
                                  top: 17.H,
                                  bottom: 17.H),
                              child: Row(
                                children: <Widget>[
                                  Image.asset(AppImages.icBee, height: 39.H),
                                  SizedBox(width: 16.W),
                                  Text('FlirtBees Support',
                                      style:
                                          normalTextStyle(14.SP, Colors.black)),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.arrow_forward_ios,
                                              size: 10.H)))
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 39.H + 16.W),
                                height: 1.H,
                                color: AppColors.warmGrey2)
                          ],
                        ),
                      if (context.watch<LoginProvider>().isLoggedIn &&
                          provider.isExpanded)
                        if (provider.isEditing)
                          Expanded(child: messagesContainer)
                        else
                          messagesContainer
                      else
                        Container(),
                      if (provider.isEditing || provider.isExpanded)
                        Container()
                      else
                        Column(
                          children: <Widget>[
                            Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      context
                                          .read<MessagesProvider>()
                                          .filterMessage(
                                              type: MessageFilter.all);
                                      provider.toggleExpand();
                                    },
                                    child: const MessageCategory(
                                        title: 'All friends')),
                                const MessageCategory(title: 'Friends online'),
                                InkWell(
                                    onTap: () {
                                      context
                                          .read<MessagesProvider>()
                                          .filterMessage(
                                              type: MessageFilter.favourites);
                                      provider.toggleExpand();
                                    },
                                    child: const MessageCategory(
                                        title: 'Favourites')),
                                const MessageCategory(title: 'Unread'),
                              ],
                            ),
                          ],
                        ),
                    ],
                  )
                ],
              ));
          if (provider.isEditing) {
            return content;
          }
          return SingleChildScrollView(
            child: content,
          );
        }),
        if (context.watch<CallingProvider>().state ==
            SignalingState.CallStateConnected)
          CameraBubble()
        else
          Container()
      ],
    );
  }
}

class MessageCategory extends StatelessWidget {
  const MessageCategory(
      {Key key,
      this.title,
      this.trailing,
      this.titleColor,
      this.notPaddingLine = false})
      : super(key: key);

  final String title;
  final Widget trailing;
  final Color titleColor;
  final bool notPaddingLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 46.H,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 33.W,
            bottom: 0,
            top: 0,
            left: 15.W,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title,
                    style: normalTextStyle(14.SP, titleColor ?? Colors.black)),
                trailing ?? Container()
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: notPaddingLine ? 0 : 15.W,
            child: Container(height: 1.H, color: AppColors.warmGrey2),
          ),
        ],
      ),
    );
  }
}

class MessageSlot extends StatelessWidget {
  MessageSlot({Key key, this.friend}) : super(key: key);

  final Friend friend;

  bool isOnline = false;
  MessageSlotStatus status = MessageSlotStatus.none;
  String time = '10:00';
  int unreadMessageCount = 0;

  Color getLastMessageColor() {
    if (friend.isFullFriend || friend.isRequestFriend) {
      return Colors.green;
    }
    return AppColors.steel;
  }

  String getLastMessage(Friend friend) {
    if (friend.lastMessage != null) {
      return friend.lastMessage.bodyMessage.value;
    } else {
      if (friend.isRequestFriend) {
        return 'Want to add you as a friend';
      }
      if (friend.isFullFriend) {
        return 'You are now friend';
      }
    }

  }

  bool getOnlineStatus(Friend friend, BuildContext context) {
    // ignore: unnecessary_parenthesis
    return (context.watch<SocketHelper>().friendOnlines[friend.uid] != null);
  }

  Future<void> handlePressFavorite(BuildContext context) async {
    bool isSuccess = false;
    context.read<AppLoadingProvider>().showLoading(context);
    if (friend.isFavorite) {
      isSuccess = await Provider.of<MessagesProvider>(context, listen: false)
          .deleteFavouriteFriend(friendId: friend.uid);
    } else {
      isSuccess = await Provider.of<MessagesProvider>(context, listen: false)
          .favouriteFriend(friendId: friend.uid);
    }
    if (isSuccess) {
      await context.read<MessagesProvider>().getListFriends();
      context.read<AppLoadingProvider>().hideLoading();
    } else {
      context.read<AppLoadingProvider>().hideLoading();
    }
  }

  Future<void> deleteFriend(BuildContext context) async {
    context.read<AppLoadingProvider>().showLoading(context);
    final bool isSuccess =
        await Provider.of<MessagesProvider>(context, listen: false)
            .unFriend(friendId: friend.uid);
    if (isSuccess) {
      await context.read<MessagesProvider>().getListFriends();
      context.read<AppLoadingProvider>().hideLoading();
    } else {
      context.read<AppLoadingProvider>().hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = context.watch<MessagesProvider>().isEditing;
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        SlideAction(
          child: InkWell(
            onTap: () async {
              await handlePressFavorite(context);
            },
            child: Container(
              color: AppColors.blueSlidable,
              child: Center(
                child: (friend.isFavorite != null)
                    ? (friend.isFavorite)
                        ? Image.asset(AppImages.icHeart)
                        : Image.asset(AppImages.icHeartWhite)
                    : Image.asset(AppImages.icHeartWhite),
              ),
            ),
          ),
        ),
        SlideAction(
          child: InkWell(
            onTap: () async {
              await deleteFriend(context);
            },
            child: Container(
              color: AppColors.redSlidable,
              child: Center(
                child: Image.asset(AppImages.icTrash),
              ),
            ),
          ),
        ),
      ],
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: isEditing ? 5.W : 15.W,
                right: 33.W,
                top: 17.H,
                bottom: 17.H),
            child: Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    if (friend.avatar != null)
                      Stack(
                        children: [
                          Container(
                              width: 39.W,
                              height: 39.W,
                              decoration: BoxDecoration(
                                  color: AppColors.white3,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(AppHelper.getImageUrl(
                                          imageName: friend.avatar)),
                                      fit: BoxFit.fill))),
                          if (getOnlineStatus(friend, context)) Positioned(
                            right: 1.W,
                            bottom: 1.W,
                            child: Container(
                              width: 8.W,
                              height: 8.W,
                              child: Image.asset(AppImages.icDotOnline),
                            ),
                          ) else Container()
                        ],
                      )
                    else
                      Image.asset(AppImages.women3, height: 39.H),
                    if (isOnline)
                      Positioned(
                        bottom: 1.W,
                        right: 1.W,
                        child: Container(
                          height: 8.W,
                          width: 8.W,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              border: Border.all(color: Colors.white)),
                        ),
                      )
                    else
                      Container()
                  ],
                ),
                SizedBox(width: 16.W),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(friend.name,
                          style: normalTextStyle(14.SP, Colors.black)),
                      SizedBox(height: 2.H),
                      Text(
                        getLastMessage(friend),
                        style: normalTextStyle(14.SP, getLastMessageColor()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (status == MessageSlotStatus.received)
                              Image.asset(AppImages.icMessageReceived)
                            else if (status == MessageSlotStatus.sent)
                              Image.asset(AppImages.icMessageSent)
                            else
                              Container(),
                            SizedBox(width: 4.W),
                            Text(AppHelper.getDateTimeStringFormatHHmm(friend.lastMessage?.createdAt ?? ''),
                                style: normalTextStyle(10.SP, AppColors.steel)),
                          ],
                        ),
                        if (unreadMessageCount > 0)
                          Container(
                            height: 15.H,
                            width: 17.H,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.W)),
                                color: AppColors.darkGreyBlue),
                            child: Center(
                                child: Text('$unreadMessageCount',
                                    style:
                                        normalTextStyle(10.SP, Colors.white))),
                          )
                        else
                          Container(height: 15.H)
                      ],
                    ))
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: isEditing ? 17.W * 2 + 20.W + 5.W : 39.H + 16.W),
              height: 1.H,
              color: AppColors.warmGrey2)
        ],
      ),
    );
  }
}

enum MessageSlotStatus { none, sent, received }
