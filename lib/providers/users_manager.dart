import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';

class UsersManager extends ChangeNotifier {
  final Map<String, User?> _usersData = {};

  Map<String, User?> get usersData => _usersData;

  updateUpUserNames(bool setUp, [Map<String, User>? users]) {
    if (users != null) {
      users.forEach((user, data) {
        _usersData[user] = data;
      });
    }
    notifyListeners();
  }
}
