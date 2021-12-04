import 'dart:async';

import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  bool _isUserNamesSetUp = false;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  bool get isUserNamesSetUp => _isUserNamesSetUp;
  bool get isLoggedIn => _isLoggedIn;

  setUpUserNames() {
    _isUserNamesSetUp = false;
    notifyListeners();
  }

  Future<bool> leaveUserNamesSetup() {
    _isUserNamesSetUp = true;
    notifyListeners();
    return Future.value(true);
  }

  finishLoading() {
    _isLoading = false;
    notifyListeners();
  }

  logIn() {
    _isUserNamesSetUp = true;
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  logOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
