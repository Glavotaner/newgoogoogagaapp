import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';

class UsersManager extends ChangeNotifier {
  final Map<String, User?> _usersData = {};
  bool _isWaitingForToken = false;

  Map<String, User?> get usersData => _usersData;
  bool get isWaitingForToken => _isWaitingForToken;

  updateUserNames(Map<String, User> users) {
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
