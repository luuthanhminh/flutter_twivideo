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
  "data": true
}
 */

class AcceptFriendResponse {
  AcceptFriendResponse(Map<String, dynamic> fullJson):
        isDone = fullJson['data'] as bool;

  bool isDone;

  Map<String, dynamic> dataToJson() {
    return <String, dynamic>{'data' : isDone};
  }
}
