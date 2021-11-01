import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';

class AppStateManager extends ChangeNotifier {
  bool _userNamesSetUp = false;
  bool _initialized = false;
  bool _loading = true;
  bool _loggedIn = false;
  Map<String, User?> _usersData = {};

  bool get isUserNamesSetUp => _userNamesSetUp;
  bool get isinitialized => _initialized;
  bool get isLoading => _loading;
  bool get isLoggedIn => _loggedIn;
  Map<String, User?> get usersData => _usersData;

  setUpUserNames(bool setUp, [Map<String, User>? users]) {
    if (users != null) {
      users.forEach((user, data) {
        _usersData[user] = data;
      });
    }
    _userNamesSetUp = setUp;
    _loggedIn = true;
    notifyListeners();
  }

  initializeMessaging() {
    _initialized = true;
    notifyListeners();
  }

  finishLoading() {
    _loading = false;
    notifyListeners();
  }

  logIn() {
    _loggedIn = true;
    _loading = false;
    notifyListeners();
  }

  logOut() {
    _loggedIn = false;
    notifyListeners();
  }
}
