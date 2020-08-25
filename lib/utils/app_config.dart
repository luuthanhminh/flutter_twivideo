import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Environment declare here
class Env {
  Env._({
    @required this.socketHost,
    @required this.socketPort,
    @required this.apiBaseUrl,
  });

  factory Env.dev() {
    return Env._(
      socketHost: '104.248.90.40',
      socketPort: 3001,
      apiBaseUrl: 'http://104.248.90.40:3001',
    );
  }

  factory Env.prod() {
    return Env._(
      socketHost: '104.248.90.40',
      socketPort: 3000,
      apiBaseUrl: 'http://104.248.90.40:3000',
    );
  }

  final String socketHost;
  final int socketPort;
  final String apiBaseUrl;
}

/// Config env
class Config {
  factory Config({Env environment}) {
    if (environment != null) {
      instance.env = environment;
    }
    return instance;
  }

  Config._private();

  static final Config instance = Config._private();

  Env env;
}
