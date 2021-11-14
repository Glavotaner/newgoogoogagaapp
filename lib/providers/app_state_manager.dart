import 'dart:async';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/alerts.dart';

class AppStateManager extends ChangeNotifier {
  bool snackbarExists = false;
  bool alertExists = false;

  bool _isUserNamesSetUp = false;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  DateTime? _backPressTimestamp;

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

  Future<bool> leaveApp(BuildContext context) {
    if (_backPressTimestamp == null) {
      Timer(Duration(seconds: 3), () => _backPressTimestamp = null);
      _backPressTimestamp = DateTime.now();
      showErrorSnackbar(context, 'Tap back button again to leave app');
      return Future.value(true);
    }
    return Future.value(false);
  }
}
