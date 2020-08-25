
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SocketHelper with ChangeNotifier {
  Map<String, bool> friendOnlines = <String, bool>{};

  void setFriendsOnline({List<String> friends}) {
    friends.forEach((String uid) {
      friendOnlines[uid] = true;
    });
    notifyListeners();
  }

  void addMemberOnline({String uid}) {
    friendOnlines[uid] = true;
    notifyListeners();
  }

  void removeMemberOffline({String uid}) {
    friendOnlines.remove(uid);
    notifyListeners();
  }


}