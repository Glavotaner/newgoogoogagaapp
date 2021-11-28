import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user/user.dart';

class UsersManager extends ChangeNotifier {
  final NullableUsersData _usersData = {};
  bool _isWaitingForToken = false;

  NullableUsersData get usersData => _usersData;
  bool get isWaitingForToken => _isWaitingForToken;

  updateUserNames(NullableUsersData users) {
    for (var user in users.entries) {
      _usersData[user.key] = user.value;
    }
    notifyListeners();
  }

  startSearchingForToken() {
    _isWaitingForToken = true;
    notifyListeners();
  }

  stopSearchingForToken() {
    _isWaitingForToken = false;
    notifyListeners();
  }
}
