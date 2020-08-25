/*
  {
    "ages": 20,
    "gender": 1,
    "uid": "Cqdz43IQg5fB4v3BRgQttPnjiDA2",
    "name": "Nhan cv",
    "avatar": "a71e6bcce783d22a9fc33f391365d647"
  }
*/

import 'package:flirtbees/models/remote/base_response.dart';

class User {
  User({this.ages, this.gender, this.uid, this.name, this.avatar, this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
    uid: json['uid'] as String,
    name: json['name'] as String,
    avatar: json['avatar'] as String,
    ages: json['ages'] as int,
    gender: json['gender'] as int,
    email: json['email'] as String
  );

  final int ages;
  final int gender;
  final String uid;
  final String name;
  final String avatar;
  final String email;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': uid,
    'gender': gender,
    'ages': ages,
    'name': name,
    'avatar': avatar,
    'email': email
  };
}

class UserResponse extends BaseResponse<User> {
  UserResponse(Map<String, dynamic> fullJson) : super(fullJson);

  @override
  Map<String, dynamic> dataToJson(User data) {
    return data.toJson();
  }

  @override
  User jsonToData(Map<String, dynamic> dataJson) {
    return User.fromJson(dataJson);
  }
}

