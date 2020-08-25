import 'package:flirtbees/pages/webrtc/signaling.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignalingProvider with ChangeNotifier {
  SignalingProvider(this.localStorage);

  final LocalStorage localStorage;
  Signaling signaling;
  bool _isConnecting = false;



}
