
class AcceptFriend {
  AcceptFriend({this.left});

  final String left;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'left': left,
  };
}

class DeclineFriend {
  DeclineFriend({this.left});

  final String left;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'left': left,
  };
}

class FavouriteFriend {
  FavouriteFriend({this.right});

  final String right;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'right': right,
  };
}

class UnFriend {
  UnFriend({this.right});

  final String right;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'right': right,
  };
}