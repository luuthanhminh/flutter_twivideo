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
  "uid": "string",
  "device_id": "string",
  "fcm_token": "string",
  "unread": 0,
  "created_at": 0,
  "updated_at": 0
}
 */

import '../base_response.dart';

class UpdateNotification {

  UpdateNotification({this.uid, this.deviceId, this.fcmToken, this.unread, this.createdAt, this.updatedAt});

  factory UpdateNotification.fromJson(Map<String, dynamic> json) => UpdateNotification(
    uid: json['uid'] as String,
    deviceId: json['device_id'] as String,
    fcmToken: json['fcm_token'] as String,
    unread: json['unread'] as int,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
  );

  final String uid;
  final String deviceId;
  final String fcmToken;
  final int unread;
  final String createdAt;
  final String updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': uid,
    'device_id': deviceId,
    'fcm_token': fcmToken,
    'unread': unread,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class UpdateNotificationResponse extends BaseResponse<UpdateNotification> {
  UpdateNotificationResponse(Map<String, dynamic> fullJson) : super(fullJson);

  @override
  Map<String, dynamic> dataToJson(UpdateNotification data) {
    return data.toJson();
  }

  @override
  UpdateNotification jsonToData(Map<String, dynamic> dataJson) {
    return UpdateNotification.fromJson(dataJson);
  }
}
