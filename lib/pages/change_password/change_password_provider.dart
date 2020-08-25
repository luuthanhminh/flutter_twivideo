
import 'package:flutter/cupertino.dart';

class ChangePasswordProvider with ChangeNotifier {
  String newPassword;
  String confirmPassword;
  bool isVerified = false;

  void verifyPassword() {
    // ignore: unnecessary_parenthesis
    isVerified = (newPassword == confirmPassword);
    notifyListeners();
  }
}