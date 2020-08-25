
import 'package:flutter/material.dart';

class PurchaseProvider with ChangeNotifier {
  int numberMonthPurchase = 12;

  void updateNumberMonthPurchase({int numberMonth}) {
    numberMonthPurchase = numberMonth;
    notifyListeners();
  }
}