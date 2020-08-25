// ignore: library_prefixes
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/utils/socket_helper.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef OnMessageCallback = void Function(String tag, dynamic msg);
typedef OnCloseCallback = void Function(int code, String reason);
typedef OnOpenCallback = void Function();

// request call
// ignore: constant_identifier_names
const String REQUEST_CALL_EVENT = 'request-call-event'; // server send-recv
// peer decline a call, forward event to host
// ignore: constant_identifier_names
const String DECLINE_CALL_EVENT = 'decline-call-event'; // server send-recv
// peer decline a call, forward event to other peers
// ignore: constant_identifier_names
const String DECLINE_CALL_PEER_EVENT = 'decline-call-peer-event'; // server send
// peer accept call
// ignore: constant_identifier_names
const String CALL_ACCEPTED_EVENT = 'call-accepted-event'; // server send
// send broadcast event to other peers when one instance accepted call
// ignore: constant_identifier_names
const String CALL_ACCEPTED_PEER_EVENT =
    'call-accepted-peer-event'; // server send

// when call error
// ignore: constant_identifier_names
const String CALL_ERROR_EVENT = 'call-error-event'; // server send
// when call error
// ignore: constant_identifier_names
const String MESSAGE_ERROR_EVENT = 'message-error-event'; // server send

// host send offer to client
// ignore: constant_identifier_names
const String OFFER_EVENT = 'offer-event'; // server send-recv
// when host or peer already in another call
// ignore: constant_identifier_names
const String OFFER_ERROR_EVENT = 'offer-error-event'; // server send
// peer accept call offer and send answer to host
// ignore: constant_identifier_names
const String ANSWER_EVENT = 'answer-event'; // server send-recv
// host and peer exchange ice
// ignore: constant_identifier_names
const String ICE_CANDIDATE_EVENT = 'ice-candidate-event'; // server send-recv
// when sign out the call
// ignore: constant_identifier_names
const String SIGN_OUT_EVENT = 'sign-out-event'; // server send-recv
// messaging
// ignore: constant_identifier_names
const String MESSAGE_EVENT = 'message-event'; // server send-recv
// this event send to sender after receiver read message
// ignore: constant_identifier_names
const String MESSAGE_READ_EVENT = 'message-read-event'; // server send

// online list. When A connect to server, server will send all online A's friend
// ignore: constant_identifier_names
const String ONLINE_LIST_EVENT = 'online-list-event';
// online. When A online, send to friend of A
// ignore: constant_identifier_names
const String ONLINE_EVENT = 'online-event';

// offline. When A offline, send to friend of A
// ignore: constant_identifier_names
const String OFFLINE_EVENT = 'offline-event';




class SimpleWebSocket {
  SimpleWebSocket(this.url, this.localStorage);

  String url;
  IO.Socket socket;
  OnOpenCallback onOpen;
  OnMessageCallback onMessage;
  OnCloseCallback onClose;
  final LocalStorage localStorage;

  Future<void> connect({Map<String, String> header}) async {
    final String token = await localStorage.getToken();
    if (token == null) {
      return;
    }
    try {
      final String token = await localStorage.getToken();
      socket = IO.io(url, <String, dynamic>{
        'transports': <String>['websocket'],
        'autoConnect': true,
        'forceNew': false,
        'extraHeaders': <String, dynamic>{'Authorization': 'Bearer $token'}
      });
      // Dart client
      socket.on('connect', (dynamic _) {
        // ignore: avoid_print
        print('connected');
        onOpen();
      });
      // Request call
      socket.on(REQUEST_CALL_EVENT, (dynamic data) {
        debugPrint('REQUEST_CALL_EVENT');
        // Emit: data: { peerId: string }
        // Recv: Data
        // {
        //    from_id: hostId,
        //    user: host
        //}
        onMessage(REQUEST_CALL_EVENT, data);
      });
      // Host send offer to peer
      // If peer decline that offer, peer send this event
      // Server forward this event to host
      // Server forward this event to other peers
      socket.on(DECLINE_CALL_EVENT, (dynamic data) {
        debugPrint('DECLINE_CALL_EVENT');
        onMessage(DECLINE_CALL_EVENT, data);
      });
      // Due to one user can have multi socket instance
      // When any instance decline call,
      // server send broadcast to the other peers to close calling dialog
      socket.on(DECLINE_CALL_PEER_EVENT, (dynamic data) {
        debugPrint('DECLINE_CALL_PEER_EVENT');
        onMessage(DECLINE_CALL_PEER_EVENT, data);
      });
      // Call accepted by peer
      socket.on(CALL_ACCEPTED_EVENT, (dynamic data) {
        debugPrint('CALL_ACCEPTED_EVENT');
        onMessage(CALL_ACCEPTED_EVENT, data);
      });
      // Due to one user can have multi socket instance
      // When any instance accept call,
      // server send broadcast to the other peers to close calling dialog
      socket.on(CALL_ACCEPTED_PEER_EVENT, (dynamic data) {
        debugPrint('CALL_ACCEPTED_PEER_EVENT');
        onMessage(CALL_ACCEPTED_PEER_EVENT, data);
      });
      // Host create a call by sending an offer to server
      // Server will forward that offer to all peer socket instances
      socket.on(OFFER_EVENT, (dynamic data) {
        debugPrint('ON OFFER EVENT IN WEBSOCKET');
        onMessage(OFFER_EVENT, data);
      });

      socket.on(CALL_ERROR_EVENT, (dynamic data) {
        debugPrint('ON CALL_ERROR_EVENT');
        onMessage(CALL_ERROR_EVENT, data);
      });

      socket.on(MESSAGE_ERROR_EVENT, (dynamic data) {
        debugPrint('ON MESSAGE_ERROR_EVENT IN WEBSOCKET');
        onMessage(MESSAGE_ERROR_EVENT, data);
      });
      // onOfferEvent: Host[${hostId}] already in call
      // onOfferEvent: Peer[${peerId}] already in call
      socket.on(OFFER_ERROR_EVENT, (dynamic data) {
        debugPrint('OFFER_ERROR_EVENT');
        onMessage(OFFER_ERROR_EVENT, data);
      });
      // After peer received offer sent by host
      // Peer sent an answer to server
      // Server will forward that answer to host who create offer
      // Server will send offer picked event to other peers
      socket.on(ANSWER_EVENT, (dynamic data) {
        debugPrint('ANSWER_EVENT');
        onMessage(ANSWER_EVENT, data);
      });
      // When both host get the answer
      // both host and peer exchange ICE
      socket.on(ICE_CANDIDATE_EVENT, (dynamic data) {
        onMessage(ICE_CANDIDATE_EVENT, data);
      });
      // In calling, host or peer can sign out of call
      // Server forward this event to the other
      socket.on(SIGN_OUT_EVENT, (dynamic data) {
        debugPrint('SIGN_OUT_EVENT');
        onMessage(SIGN_OUT_EVENT, data);
      });
      // Messages
      socket.on(MESSAGE_EVENT, (dynamic data) {
        debugPrint('MESSAGE_EVENT');
        onMessage(MESSAGE_EVENT, data);
      });
      // Message read event from receiver
      socket.on(MESSAGE_READ_EVENT, (dynamic data) {
        debugPrint('MESSAGE_READ_EVENT');
        onMessage(MESSAGE_READ_EVENT, data);
      });

      socket.on(ONLINE_LIST_EVENT, (dynamic data) {
        debugPrint('ONLINE_LIST_EVENT data ${data}');
        onMessage(ONLINE_LIST_EVENT, data);
      });

      socket.on(ONLINE_EVENT, (dynamic data) {
        debugPrint('ONLINE_EVENT data ${data}');
        onMessage(ONLINE_EVENT, data);
      });

      socket.on(OFFLINE_EVENT, (dynamic data) {
        debugPrint('OFFLINE_EVENT data ${data}');
        onMessage(OFFLINE_EVENT, data);
      });


      // ignore: avoid_print
      socket.on('exception', (dynamic e) => print('Exception: $e'));
      // ignore: avoid_print
      socket.on('connect_error', (dynamic e) => print('Connect error: $e'));
      socket.on('disconnect', (dynamic e) {
        // ignore: avoid_print
        print('disconnect');
        onClose(0, e as String);
      });
      // ignore: avoid_print
      socket.on('fromServer', (dynamic _) => print(_));
    } on Exception catch (_, e) {
      // ignore: avoid_print
      print(e);
      onClose(500, e.toString());
    }
  }

  void send(String event, dynamic data) {
    if (socket != null) {
      socket.emit(event, data);
      // ignore: avoid_print
      print('send: $event - $data');
    }
  }

  void close() {
    if (socket != null) {
      socket.disconnect();
      socket.close();
      socket.destroy();
      socket = null;
    }
  }
}
