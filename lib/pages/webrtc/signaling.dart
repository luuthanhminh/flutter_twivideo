/*
 * MIT License
 *
 * Copyright (c) 2020 Nhan Cao
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flirtbees/models/remote/message.dart';
import 'package:flirtbees/pages/webrtc/device_info.dart';
import 'package:flirtbees/pages/webrtc/turn.dart';
import 'package:flirtbees/pages/webrtc/websocket.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum SignalingState {
  // ignore: constant_identifier_names
  CallStateRequest,
  // ignore: constant_identifier_names
  CallStateNew,
  // ignore: constant_identifier_names
  CallStateRinging,
  // ignore: constant_identifier_names
  CallStateInvite,
  // ignore: constant_identifier_names
  CallStateConnected,
  // ignore: constant_identifier_names
  CallStateBye,
  // ignore: constant_identifier_names
  ConnectionOpen,
  // ignore: constant_identifier_names
  ConnectionClosed,
  // ignore: constant_identifier_names
  ConnectionError,
}

/*
 * callbacks for Signaling API.
 */
typedef SignalingStateCallback = void Function(SignalingState state);
typedef StreamStateCallback = void Function(MediaStream stream);
typedef OtherEventCallback = void Function(dynamic event);
typedef DataChannelMessageCallback = void Function(
    RTCDataChannel dc, RTCDataChannelMessage data);
typedef DataChannelCallback = void Function(RTCDataChannel dc);
typedef OnReceivedCallingCallback = void Function(Map<String, dynamic> user);
typedef OnReceivedMessageCallback = void Function(MessageResponse messageResponse);
typedef OnReceivedAnswer = void Function();
typedef OnReceivedSocketWhenConnectCallback = void Function(Map<String, dynamic> friends);
typedef OnReceivedSocketFriendOnlineCallback = void Function(Map<String, dynamic> friend);
typedef OnReceivedSocketFriendOfflineCallback = void Function(Map<String, dynamic> friend);

class Signaling {
  Signaling(this._host, this._port, {this.localStorage});

  SimpleWebSocket _socket;
  final String _host;
  final int _port;
  RTCPeerConnection peerConnection;
  RTCDataChannel dataChannel;
  final List<RTCIceCandidate> _remoteCandidates = <RTCIceCandidate>[];
  Map<String, dynamic> _turnCredential;
  LocalStorage localStorage;

  MediaStream _localStream;
  List<MediaStream> _remoteStreams;
  SignalingStateCallback onStateChange;
  StreamStateCallback onLocalStream;
  StreamStateCallback onAddRemoteStream;
  StreamStateCallback onRemoveRemoteStream;
  OtherEventCallback onPeersUpdate;
  OtherEventCallback onEventUpdate;
  DataChannelMessageCallback onDataChannelMessage;
  DataChannelCallback onDataChannel;
  OnReceivedCallingCallback onReceivedCalling;
  OnReceivedMessageCallback onReceivedMessageCallback;
  OnReceivedAnswer onReceivedAnswer;
  OnReceivedSocketWhenConnectCallback onReceivedSocketWhenConnectCallback;
  OnReceivedSocketFriendOnlineCallback onReceivedSocketFriendOnlineCallback;
  OnReceivedSocketFriendOfflineCallback onReceivedSocketFriendOfflineCallback;


  // For offer
  String id = 'caller';
  String media = 'call';
  String fromId;
  Map<String, dynamic> user;
  Map<String, dynamic> description;

  Map<String, dynamic> _iceServers = <String, dynamic>{
    'iceServers': <dynamic>[
      <String, String>{'url': 'stun:stun.l.google.com:19302'},
      /*
       * turn server configuration example.
      {
        'url': 'turn:123.45.67.89:3478',
        'username': 'change_to_real_user',
        'credential': 'change_to_real_secret'
      },
       */
    ]
  };

  final Map<String, dynamic> _config = <String, dynamic>{
    'mandatory': <String, dynamic>{},
    'optional': <dynamic>[
      <String, bool>{'DtlsSrtpKeyAgreement': true},
    ],
  };

  final Map<String, dynamic> _constraints = <String, dynamic>{
    'mandatory': <String, bool>{
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': <dynamic>[],
  };

  final Map<String, dynamic> _dcConstraints = <String, dynamic>{
    'mandatory': <String, bool>{
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': <dynamic>[],
  };

  void close() {
    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }

    if (peerConnection != null) {
      peerConnection.close();
    }
  }

  void closeSocket() {
    if(_socket != null) {
      _socket.close();
    }
  }

  void switchCamera() {
    if (_localStream != null) {
      _localStream.getVideoTracks()[0].switchCamera();
    }
  }

  // ignore: avoid_positional_boolean_parameters
  void invite(String peerId, String media, bool useScreen) {
    emitRequestCallEvent(peerId);
    onStateChange(SignalingState.CallStateRequest);
  }

  void bye({bool isActive = true}) {
    if(isActive && peerConnection != null) {
      emitSignOutEvent();
    }

    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }

    if (dataChannel != null) {
      dataChannel.close();
    }
    if (peerConnection != null) {
      peerConnection.close();
    }
    _remoteCandidates.clear();

    if(onStateChange != null) {
       onStateChange(null);
    }
  }

  Future<void> acceptCall() async {
    emitCallAcceptedEvent();
  }

  Future<void> rejectCall() async {
    debugPrint('rejectCall');
    bye(isActive: false);
  }

  void initOffer(String peerId) {
    if (onStateChange != null) {
      onStateChange(SignalingState.CallStateNew);
    }

    _createPeerConnection(peerId, media, false, isHost: true)
        .then((RTCPeerConnection pc) {
      peerConnection = pc;

      _createDataChannel(peerId, pc);

      if (media == 'data') {

      }
      _createOffer(peerId, pc, media);
    });
  }

  Future<void> onMessage(String tag, Map<String, dynamic> message) async {
    switch (tag) {
      case REQUEST_CALL_EVENT:
        debugPrint('Model message on calling: ${message}');
        fromId = message['from_id'] as String;
        user = message['user'] as Map<String, dynamic>;
        // Show calling popup
        if (onReceivedCalling != null) {
          onReceivedCalling(user);
        }

        break;
      case CALL_ACCEPTED_EVENT:
        final String peerId = message['from_id'] as String;
        initOffer(peerId);
        break;

      case OFFER_EVENT:
        {
          debugPrint('On offer event call in Signalling');
          fromId = message['from_id'] as String;
          description = message['data'] as Map<String, dynamic>;

          if (onStateChange != null) {
            onStateChange(SignalingState.CallStateNew);
          }

          // Create peer connection
          final RTCPeerConnection pc = await _createPeerConnection(id, media, false);
          peerConnection = pc;
          // Set remote
          await pc.setRemoteDescription(RTCSessionDescription(
              description['sdp'] as String, description['type'] as String));

          // Send answer to caller
          await _createAnswer(id, pc, media);
          // Send ICE
          if (_remoteCandidates.isNotEmpty) {
            // ignore: avoid_function_literals_in_foreach_calls
            _remoteCandidates.forEach((RTCIceCandidate candidate) async {
              await pc.addCandidate(candidate);
            });
            _remoteCandidates.clear();
          }
        }
        break;
      case ANSWER_EVENT:
        {
          debugPrint('On ANSWER_EVENT: Connected');
          onReceivedAnswer();
          fromId = message['from_id'] as String;
          final Map<String, dynamic> description =
              message['data'] as Map<String, dynamic>;
          final RTCPeerConnection pc = peerConnection;
          if (pc != null) {
            await pc.setRemoteDescription(RTCSessionDescription(
                description['sdp'] as String, description['type'] as String));
          } 
        }
        break;
      case ICE_CANDIDATE_EVENT:
        {
          final String fromId = message['from_id'] as String;
          final Map<String, dynamic> candidateMap =
              message['data'] as Map<String, dynamic>;
          if (candidateMap != null) {
            final RTCPeerConnection pc = peerConnection;
            final RTCIceCandidate candidate = RTCIceCandidate(
                candidateMap['candidate'] as String,
                candidateMap['sdpMid'] as String,
                candidateMap['sdpMLineIndex'] as int);
            if (pc != null) {
              await pc.addCandidate(candidate);
            } else {
              _remoteCandidates.add(candidate);
            }
          }
        }
        break;
      case SIGN_OUT_EVENT:
        {
          debugPrint('SIGN_OUT_EVENT');
          if (onStateChange != null) {
            onStateChange(SignalingState.ConnectionClosed);
          }
          rejectCall();
        }
        break;
      case MESSAGE_EVENT:
        {
          debugPrint('On message event: ${message}');
          final MessageResponse messageResponse = MessageResponse.fromJson(message);
          if (onReceivedMessageCallback != null) {
            onReceivedMessageCallback(messageResponse);
          }
        }
        break;
      case ONLINE_LIST_EVENT:
        {
          if (onReceivedSocketWhenConnectCallback != null) {
            onReceivedSocketWhenConnectCallback(message);
          }
        }
        break;
      case ONLINE_EVENT:
        {
          if (onReceivedSocketFriendOnlineCallback != null) {
            onReceivedSocketFriendOnlineCallback(message);
          }
        }
        break;
      case OFFLINE_EVENT:
        {
          if (onReceivedSocketFriendOfflineCallback != null) {
            onReceivedSocketFriendOfflineCallback(message);
          }
        }
        break;
      case CALL_ERROR_EVENT:
        {
          Fluttertoast.showToast(msg: message.toString());
        }
        break;
      case MESSAGE_ERROR_EVENT:
        {
          Fluttertoast.showToast(msg: message.toString());
        }
        break;
      default:
        break;
    }
  }

  Future<void> connect() async {
    final String token = await localStorage.getToken();
    if (token == null) {
      return;
    }
    final String url = 'http://$_host:$_port';
    if(_socket != null) {
      debugPrint('close');
      _socket.close();
      _socket = null;
    }
    _socket = SimpleWebSocket(url, localStorage);

    // ignore: avoid_print
    debugPrint('connect to $url');

    if (_turnCredential == null) {
      try {
        _turnCredential = await getTurnCredential(_host, _port);
        /*{
            "username": "1584195784:mbzrxpgjys",
            "password": "isyl6FF6nqMTB9/ig5MrMRUXqZg",
            "ttl": 86400,
            "uris": ["turn:127.0.0.1:19302?transport=udp"]
          }
        */
        _iceServers = <String, dynamic>{
          'iceServers': <dynamic>[
            <String, dynamic>{
              'url': _turnCredential['uris'][0],
              'username': _turnCredential['username'],
              'credential': _turnCredential['password']
            },
          ]
        };
      } catch (e) {
        // ignore: avoid_print
        print('connect $e');
      }
    }

    _socket.onOpen = () {
      // ignore: avoid_print
      print('onOpen');
      onStateChange(SignalingState.ConnectionOpen);
      // ignore: avoid_print
      print(<String, dynamic>{
        'name': DeviceInfo.label,
        'user_agent': DeviceInfo.userAgent
      });
    };

    _socket.onMessage = (String tag, dynamic message) {
      // ignore: avoid_print
      print('Received data: $tag - $message');
      onMessage(tag, message as Map<String, dynamic>);
    };

    _socket.onClose = (int code, String reason) {
      // ignore: avoid_print
      print('Closed by server [$code => $reason]!');
      if (onStateChange != null) {
        onStateChange(SignalingState.ConnectionClosed);
      }
    };

    return _socket.connect();
  }

  // ignore: avoid_positional_boolean_parameters
  Future<MediaStream> createStream(String media, bool userScreen) async {
    final Map<String, dynamic> mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': <String, dynamic>{
        'mandatory': <String, String>{
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': <dynamic>[],
      }
    };

    final MediaStream stream = userScreen
        ? await navigator.getDisplayMedia(mediaConstraints)
        : await navigator.getUserMedia(mediaConstraints);
    if (onLocalStream != null) {
      onLocalStream(stream);
    }
    return stream;
  }

  Future<RTCPeerConnection> _createPeerConnection(
      String id, String media, bool userScreen,
      {bool isHost = false}) async {

    if (media != 'data') {
      _localStream = await createStream(media, userScreen);
    }
    final RTCPeerConnection pc =
        await createPeerConnection(_iceServers, _config);
    if (media != 'data') {
      pc.addStream(_localStream);
    }

    debugPrint('NhanCV: Turn on speaker phone');
    _localStream.getAudioTracks()[0].enableSpeakerphone(true);

    pc.onIceCandidate = (RTCIceCandidate candidate) {
      final Map<String, Object> iceCandidate = <String, Object>{
        'sdpMLineIndex': candidate.sdpMlineIndex,
        'sdpMid': candidate.sdpMid,
        'candidate': candidate.candidate,
      };
      emitIceCandidateEvent(isHost, iceCandidate);
    };

    pc.onIceConnectionState = (RTCIceConnectionState state) {
      // ignore: avoid_print
      print('onIceConnectionState $state');

      if(onStateChange != null){
        switch(state) {
          case RTCIceConnectionState.RTCIceConnectionStateNew:
            break;
          case RTCIceConnectionState.RTCIceConnectionStateChecking:
            onStateChange(SignalingState.CallStateRinging);
            break;
          case RTCIceConnectionState.RTCIceConnectionStateCompleted:
          case RTCIceConnectionState.RTCIceConnectionStateConnected:
            onStateChange(SignalingState.CallStateConnected);
            break;
          case RTCIceConnectionState.RTCIceConnectionStateCount:
            break;
          case RTCIceConnectionState.RTCIceConnectionStateFailed:
            onStateChange(SignalingState.ConnectionError);
            break;
          case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
          case RTCIceConnectionState.RTCIceConnectionStateClosed:
            onStateChange(SignalingState.ConnectionClosed);
            break;
        }
      }

      if (state == RTCIceConnectionState.RTCIceConnectionStateClosed ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        bye();
      }
    };

    pc.onAddStream = (MediaStream stream) {
      if (onAddRemoteStream != null) {
        onAddRemoteStream(stream);
      }
      //_remoteStreams.add(stream);
    };

    pc.onRemoveStream = (MediaStream stream) {
      if (onRemoveRemoteStream != null) {
        onRemoveRemoteStream(stream);
      }
      _remoteStreams.removeWhere((MediaStream it) {
        // ignore: unnecessary_parenthesis
        return (it.id == stream.id);
      });
    };


    pc.onDataChannel = (RTCDataChannel channel) {
      _addDataChannel(id, channel);


    };

    return pc;
  }

  void _addDataChannel(String id, RTCDataChannel channel) {
    channel.onDataChannelState = (RTCDataChannelState state) {

    };
    channel.onMessage = (RTCDataChannelMessage data) {
      if (onDataChannelMessage != null) {
        onDataChannelMessage(channel, data);
      }
    };
    debugPrint('Nhancv: add data channel');
    dataChannel = channel;

    if (onDataChannel != null) {
      onDataChannel(channel);
    }
  }

  Future<void> sendMessage({String message, String peerId}) async {
    try {
      debugPrint('PeerID: $peerId');
      final String deviceId = await AppHelper.getDeviceUUID();
      _send(MESSAGE_EVENT, <String, dynamic>{
        'peerId': peerId,
        'deviceId': deviceId,
        'body': jsonEncode({'type': 'text', 'value': message}),
      });
      debugPrint('Send message success: $message');
    } catch (e) {
      throw 'Unable to RTCPeerConnection::close: ${e.message}';
    }
  }

  Future<void> _createDataChannel(String id, RTCPeerConnection pc,
      {String label = 'fileTransfer'}) async {
    final RTCDataChannelInit dataChannelDict = RTCDataChannelInit();
    final RTCDataChannel channel =
        await pc.createDataChannel(label, dataChannelDict);
    _addDataChannel(id, channel);
  }

  Future<void> _createOffer(
      String id, RTCPeerConnection pc, String media) async {
    try {
      final RTCSessionDescription s =
          await pc.createOffer(media == 'data' ? _dcConstraints : _constraints);
      pc.setLocalDescription(s);

      final Map<String, String> description = <String, String>{
        'sdp': s.sdp,
        'type': s.type
      };
      emitOfferEvent(id, description);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> _createAnswer(
      String id, RTCPeerConnection pc, String media) async {
    try {
      final RTCSessionDescription s = await pc
          .createAnswer(media == 'data' ? _dcConstraints : _constraints);
      pc.setLocalDescription(s);

      final Map<String, dynamic> description = <String, dynamic>{
        'sdp': s.sdp,
        'type': s.type
      };
      emitAnswerEvent(description);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  void _send(String event, dynamic data) {
    _socket.send(event, data);
  }

  void emitOfferEvent(String peerId, dynamic description) {
    _send(OFFER_EVENT,
        <String, dynamic>{'peerId': peerId, 'description': description});
  }

  void emitAnswerEvent(dynamic description) {
    _send(ANSWER_EVENT, <String, dynamic>{'description': description});
  }

  // ignore: avoid_positional_boolean_parameters
  void emitIceCandidateEvent(bool isHost, dynamic candidate) {
    _send(ICE_CANDIDATE_EVENT,
        <String, dynamic>{'candidate': candidate});
  }

  void emitSignOutEvent() {
    _send(SIGN_OUT_EVENT, 'signout');
  }

  void emitDeclineCallEvent() {
    _send(DECLINE_CALL_EVENT, 'decline');
  }

  void emitRequestCallEvent(String peerId) {
    _send(REQUEST_CALL_EVENT,
        <String, dynamic>{'peerId': peerId});
  }

  void emitCallAcceptedEvent() {
    _send(CALL_ACCEPTED_EVENT, 'accepted');
  }

}
