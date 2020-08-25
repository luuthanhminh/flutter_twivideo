

import 'dart:convert';

import 'package:flirtbees/models/remote/user_response.dart';


class BodyMessage {
  BodyMessage({this.type, this.value});

  factory BodyMessage.fromJson(String json) => BodyMessage(
      type: jsonDecode(json)['type'] as String,
      value: jsonDecode(json)['value'] as String
  );

  final String type;
  String value;


}

class Message {

  Message({this.left, this.right, this.id, this.received, this.sent, this.read, this.bodyMessage, this.createdAt, this.updatedAt});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      left: json['left'] as String,
      right: json['right'] as String,
    id: json['_id'] as String,
    received: json['received'] as bool,
    sent: json['sent'] as bool,
    read: json['read'] as bool,
    bodyMessage: BodyMessage.fromJson(json['body'] as String),
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String
  );

  final String left;
  final String right;
  final String id;
  final bool received;
  final bool sent;
  final bool read;
  BodyMessage bodyMessage;
  AppMessageType messageType = AppMessageType.receive;
  String createdAt;
  String updatedAt;
  bool isLastMessageInDay = false;

}

enum AppMessageType {
  send,
  receive
}

class MessageResponse {

  MessageResponse({this.fromId, this.message, this.user});

  factory MessageResponse.fromJson(Map<String, dynamic> json) => MessageResponse(
    fromId: json['from_id'] as String,
    message: Message.fromJson(json['data'] as Map<String, dynamic>),
    user: User.fromJson(json['user'] as Map<String, dynamic>),
  );

  final String fromId;
  final Message message;
  final User user;
}