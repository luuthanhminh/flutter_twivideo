import 'package:flutter/material.dart';

class NavigatorProvider {
  NavigatorProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  Future<dynamic> push(String routeName) {
    return navigatorKey?.currentState?.pushNamed(routeName);
  }

  Future<dynamic> replace(String routeName) {
    return navigatorKey?.currentState?.pushReplacementNamed(routeName);
  }

  Future<dynamic> pushAndRemoveUntil(String routeName) {
    return navigatorKey?.currentState?.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => route.isFirst);
  }

  void pop() {
    navigatorKey?.currentState?.pop();
  }

  void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }
}