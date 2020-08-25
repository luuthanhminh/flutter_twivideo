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

class BooleanResponse {
  BooleanResponse(Map<String, dynamic> fullJson):
        isSuccessed = fullJson['data'] as bool;

  bool isSuccessed;

  Map<String, dynamic> dataToJson() {
    return <String, dynamic>{'data' : isSuccessed};
  }
}
