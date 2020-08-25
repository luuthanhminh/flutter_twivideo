
class NotificationData {
  NotificationData({this.uid, this.name, this.avatar, this.email, this.type});

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
      uid: json['uid'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      email: json['email'] as String,
    type: json['noty_type'] as String
  );

  final String uid;
  final String name;
  final String avatar;
  final String email;
  final String type;
  NotificationPayload payload;
}

class NotificationPayload {

  NotificationPayload({this.title, this.body});

  factory NotificationPayload.fromJson(Map<String, dynamic> json) => NotificationPayload(
    title: json['title'] as String,
    body: json['body'] as String,
  );

  final String title;
  final String body;

}
