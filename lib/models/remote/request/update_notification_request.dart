
class UpdateNotificationRequest {
  UpdateNotificationRequest({this.deviceId, this.fcmToken});

  factory UpdateNotificationRequest.fromJson(Map<String, dynamic> json) => UpdateNotificationRequest(
      deviceId: json['device_id'] as String,
      fcmToken: json['fcm_token'] as String
  );

  final String deviceId;
  final String fcmToken;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'device_id': deviceId,
    'fcm_token': fcmToken
  };
}