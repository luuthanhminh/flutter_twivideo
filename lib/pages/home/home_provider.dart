import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  int currentTabIndex = 0;

  void updateTabIndex(int tabIndex) {
    if (currentTabIndex != tabIndex) {
      currentTabIndex = tabIndex;
      notifyListeners();
    }
  }
}
