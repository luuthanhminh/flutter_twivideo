
import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/request/messages/messages_list_request.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'api.dart';

class MessageApi extends Api {

  MessageApi(LocalStorage localStorage) : super(localStorage);

  Future<Response<dynamic>> getListMessage({String rightId, MessageListRequest request}) async {
    final Map<String, String> header = await getAuthHeader();
    // ignore: unnecessary_string_interpolations
    return wrapE(() => dio.get<dynamic>('${Api.messageListUrl + rightId}',
        options: Options(headers: header),
        queryParameters: request.toJson()
        ));
  }

}
