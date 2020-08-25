import 'dart:core';

import 'package:flirtbees/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:provider/provider.dart';

import 'signaling.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CallProvider>(
      create: (_) => CallProvider(),
      child: const CallBody(),
    );
  }
}

class CallBody extends StatefulWidget {
  const CallBody({Key key}) : super(key: key);

  static String tag = 'call_sample';

  @override
  // ignore: no_logic_in_create_state
  _CallBodyState createState() => _CallBodyState();
}

class _CallBodyState extends State<CallBody> {
  final String _selfId = '0jfanw0ZUzSY5UuDazN3vQKZ8T32';
  Signaling _signaling;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initRenderers();
    _connect();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (_signaling != null) {
      _signaling.close();
    }
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  Future<void> _connect() async {
    if (_signaling == null) {
      _signaling = Signaling(
        Config.instance.env.socketHost,
        Config.instance.env.socketPort,
      )..connect();

      _signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            setState(() {
              _inCalling = true;
            });
            break;
          case SignalingState.CallStateBye:
            setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _inCalling = false;
            });
            break;
          case SignalingState.CallStateInvite:
          case SignalingState.CallStateConnected:
          case SignalingState.CallStateRinging:
          case SignalingState.ConnectionClosed:
          case SignalingState.ConnectionError:
          case SignalingState.ConnectionOpen:
            break;
        }
      };

      // ignore: unnecessary_parenthesis
      _signaling.onEventUpdate = ((dynamic event) {
        final String clientId = event['clientId'] as String;
        context.read<CallProvider>().updateClientIp(clientId);
      });

      // ignore: unnecessary_parenthesis
      _signaling.onPeersUpdate = ((dynamic event) {
        setState(() {
//          _selfId = '0jfanw0ZUzSY5UuDazN3vQKZ8T32';
        });
      });

      // ignore: unnecessary_parenthesis
      _signaling.onLocalStream = ((MediaStream stream) {
        _localRenderer.srcObject = stream;
      });

      // ignore: unnecessary_parenthesis
      _signaling.onAddRemoteStream = ((MediaStream stream) {
        _remoteRenderer.srcObject = stream;
      });

      // ignore: unnecessary_parenthesis
      _signaling.onRemoveRemoteStream = ((MediaStream stream) {
        _remoteRenderer.srcObject = null;
      });
    }
  }

  void _invitePeer(BuildContext context, String peerId, bool useScreen) {
    if (_signaling != null && peerId != _selfId) {
      _signaling.invite(peerId, 'video', useScreen);
    }
  }

  void _hangUp() {
    if (_signaling != null) {
      _signaling.bye();
    }
  }

  void _switchCamera() {
    _signaling.switchCamera();
  }

  void _muteMic() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CallProvider>(
          builder: (BuildContext context, CallProvider provider, _) {
            final String clientId = provider.clientId;
            return clientId.isNotEmpty
                ? Text(clientId)
                : const Text('P2P Call Sample');
          },
        ),
        actions: const <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: null,
            tooltip: 'setup',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _inCalling
          ? SizedBox(
              width: 200.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _switchCamera,
                      child: const Icon(Icons.switch_camera),
                    ),
                    FloatingActionButton(
                      onPressed: _hangUp,
                      tooltip: 'Hangup',
                      backgroundColor: Colors.pink,
                      child: const Icon(Icons.call_end),
                    ),
                    FloatingActionButton(
                      onPressed: _muteMic,
                      child: const Icon(Icons.mic_off),
                    )
                  ]))
          : null,
      body: _inCalling
          ? OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
              // ignore: avoid_unnecessary_containers
              return Container(
                child: Stack(children: <Widget>[
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(color: Colors.black54),
                        child: RTCVideoView(_remoteRenderer),
                      )),
                  Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      decoration: const BoxDecoration(color: Colors.black54),
                      child: RTCVideoView(_localRenderer),
                    ),
                  ),
                ]),
              );
            })
          : Container(
              color: Colors.yellow,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: textEditingController,
                  ),
                  FlatButton(
                    color: Colors.green,
                    onPressed: () {
                      _invitePeer(context, textEditingController.text, false);
                    },
                    child: const Text('Call'),
                  )
                ],
              ),
            ),
    );
  }
}

class CallProvider with ChangeNotifier {
  String clientId = '';

  void updateClientIp(String newClientId) {
    clientId = newClientId;
    notifyListeners();
  }
}
