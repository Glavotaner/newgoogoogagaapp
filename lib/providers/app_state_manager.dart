import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  bool _userNamesSetUp = false;
  bool _loading = true;
  bool _loggedIn = false;

  bool get isUserNamesSetUp => _userNamesSetUp;
  bool get isLoading => _loading;
  bool get isLoggedIn => _loggedIn;

  setUpUserNames() {
    _userNamesSetUp = false;
    notifyListeners();
  }

  leaveUserNamesSetup() {
    _userNamesSetUp = true;
    notifyListeners();
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
