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
    "user": null,
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJDcWR6NDNJUWc1ZkI0djNCUmdRdHRQbmppREEyIiwiaWF0IjoxNTk1NDkxNjg5LCJleHAiOjE1OTU1MzQ4ODl9.jPLfVr7X9P0p4MAvK8blN8n8VIqoR9qlvXZU41EjarA",
    "expiresIn": "12h"
}
*/

import 'package:flirtbees/models/remote/user_response.dart';

import 'base_response.dart';

class FirebaseCredential {
  FirebaseCredential({this.user, this.accessToken, this.expiresIn});

  factory FirebaseCredential.fromJson(Map<String, dynamic> json) => FirebaseCredential(
    accessToken: json['accessToken'] as String,
    expiresIn: json['expiresIn'] as String,
    user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null
  );

  final String accessToken;
  final String expiresIn;
  final User user;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'expiresIn': expiresIn,
    'accessToken': accessToken,
    'user': user.toJson()
  };
}

class FirebaseLoginResponse extends BaseResponse<FirebaseCredential> {
  FirebaseLoginResponse(Map<String, dynamic> fullJson) : super(fullJson);

  @override
  Map<String, dynamic> dataToJson(FirebaseCredential data) {
    return data.toJson();
  }

  @override
  FirebaseCredential jsonToData(Map<String, dynamic> dataJson) {
    return FirebaseCredential.fromJson(dataJson);
  }
}


