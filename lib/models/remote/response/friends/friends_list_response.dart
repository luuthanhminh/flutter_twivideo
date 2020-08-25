/*
Error
{
    "error": true,
    "data": null,
    "errors": [
        {
            "code": 1029,
            "message": "User not found!."
        }
    ]
}

Successful
{
  "data": [
    {
      "name": "Cristian Tran",
      "uid": "VOgJGdvvJHfX9RcI58mfUM1wVEC2",
      "is_request_friend": true,
      "last_message": "Wants to add you as a friend"
    }
  ]
}
 */


import 'package:flirtbees/models/remote/message.dart';

import '../../user_response.dart';

class Friend {

  Friend({this.name, this.avatar, this.uid, this.isRequestFriend = false, this.lastMessage, this.isFullFriend = false, this.isFavorite = false, this.user});

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
    name: json['name'] as String,
    avatar: json['avatar'] as String,
    uid: json['uid'] as String,
    isRequestFriend: (json['is_request_friend'] as bool) ?? false,
    lastMessage: (json['last_message'] != null) ? Message.fromJson(json['last_message'] as Map<String, dynamic>) : null,
    isFullFriend: (json['is_full_friend'] as bool) ?? false,
    isFavorite: (json['is_favorite'] as bool) ?? false,
    user: (json['user'] != null) ? User.fromJson(json['user'] as Map<String, dynamic>) : User()
  );

  final String name;
  final String avatar;
  final String uid;
  bool isRequestFriend;
  Message lastMessage;
  final bool isFullFriend;
  bool isFavorite;
  User user;


  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'uid': uid,
    'avatar': avatar,
    'is_request_friend': isRequestFriend,
    'last_message': lastMessage,
    'is_full_friend': isFullFriend,
    'is_favorite': isFavorite
  };

}