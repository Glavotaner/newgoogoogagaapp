import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';

class UsersManager extends ChangeNotifier {
  final Map<String, User?> _usersData = {};
  bool _isWaitingForToken = false;

  Map<String, User?> get usersData => _usersData;
  bool get isWaitingForToken => _isWaitingForToken;

  updateUserNames(bool setUp, [Map<String, User>? users]) {
    if (users != null) {
      users.forEach((user, data) {
        _usersData[user] = data;
      });
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
