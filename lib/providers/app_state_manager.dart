import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  bool _userNamesSetUp = false;
  bool _loading = true;
  bool _loggedIn = false;
  bool _snackbarExists = false;
  bool _alertExists = false;

  bool get isUserNamesSetUp => _userNamesSetUp;
  bool get isLoading => _loading;
  bool get isLoggedIn => _loggedIn;
  bool get snackbarExists => _snackbarExists;
  bool get alertExists => _alertExists;

  setSnackbarExists(bool exists) => _snackbarExists = exists;
  setAlertExists(bool exists) => _alertExists = exists;

  setUpUserNames() {
    _userNamesSetUp = false;
    notifyListeners();
  }

  leaveUserNamesSetup() {
    _userNamesSetUp = true;
    notifyListeners();
    return Future.value(true);
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
