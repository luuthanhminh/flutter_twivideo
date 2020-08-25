import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> getTurnCredential(String host, int port) async {
  final HttpClient client = HttpClient(context: SecurityContext());
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) {
    // ignore: avoid_print
    print('getTurnCredential: Allow self-signed certificate => $host:$port. ');
    return true;
  };
  final String url =
      'https://$host:$port/api/turn?service=turn&username=flutter-webrtc';
  final HttpClientRequest request = await client.getUrl(Uri.parse(url));
  final HttpClientResponse response = await request.close();
  final String responseBody =
      await response.transform(const Utf8Decoder()).join();
  // ignore: avoid_print
  print('getTurnCredential:response => $responseBody.');
  final Map<String, dynamic> data =
      const JsonDecoder().convert(responseBody) as Map<String, dynamic>;
  return data;
}
