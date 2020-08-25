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
    "left": "VOgJGdvvJHfX9RcI58mfUM1wVEC2",
    "right": "Cqdz43IQg5fB4v3BRgQttPnjiDA2",
    "updated_at": "2020-08-05T06:35:28.052Z",
    "created_at": "2020-08-05T06:35:28.052Z"
}
 */

import '../../base_response.dart';

class FriendRequest {
  FriendRequest({this.left, this.right, this.updateAt, this.createAt});

  factory FriendRequest.fromJson(Map<String, dynamic> json) => FriendRequest(
    left: json['left'] as String,
    right: json['right'] as String,
    updateAt: json['updated_at'] as String,
    createAt: json['created_at'] as String,
  );

  final String left;
  final String right;
  final String updateAt;
  final String createAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'left': left,
    'right': right,
    'updateAt': updateAt,
    'createAt': createAt,
  };
}

class FriendRequestResponse extends BaseResponse<FriendRequest> {
  FriendRequestResponse(Map<String, dynamic> fullJson) : super(fullJson);

  @override
  Map<String, dynamic> dataToJson(FriendRequest data) {
    return data.toJson();
  }

  @override
  FriendRequest jsonToData(Map<String, dynamic> dataJson) {
    return FriendRequest.fromJson(dataJson);
  }
}
