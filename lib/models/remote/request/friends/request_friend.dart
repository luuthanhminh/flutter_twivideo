/// Login in request form data
class RequestFriend {
  RequestFriend({this.right});

  final String right;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'right': right,
  };
}
