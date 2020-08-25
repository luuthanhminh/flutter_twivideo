class MessageListRequest {
  MessageListRequest({this.from, this.to});

  final int from;
  final int to;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'from': from,
    'to': to
  };
}