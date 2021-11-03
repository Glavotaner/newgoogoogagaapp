import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  bool _userNamesSetUp = false;
  bool _initialized = false;
  bool _loading = true;
  bool _loggedIn = false;

  bool get isUserNamesSetUp => _userNamesSetUp;
  bool get isInitialized => _initialized;
  bool get isLoading => _loading;
  bool get isLoggedIn => _loggedIn;

  enterUsersSetUp(bool setUp) {
    _userNamesSetUp = !setUp;
    notifyListeners();
  }

  initializeMessaging() {
    _initialized = true;
  }

  finishLoading() {
    _loading = false;
    notifyListeners();
  }

  logIn() {
    _userNamesSetUp = true;
    _loggedIn = true;
    _loading = false;
    notifyListeners();
  }

  logOut() {
    _loggedIn = false;
    notifyListeners();
  }
}
