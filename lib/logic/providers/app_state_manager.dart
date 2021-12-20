import 'dart:async';

import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  bool _isUsersSetUp = false;
  bool _isLoading = true;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;

  bool get isUsersSetUp => _isUsersSetUp;

  bool get isInitialized => _isInitialized;

  finishLoading() {
    _isLoading = false;
    notifyListeners();
  }

  initialize() {
    _isUsersSetUp = true;
    _isInitialized = true;
    _isLoading = false;
    notifyListeners();
  }

  enterUsersSetUp() {
    _isUsersSetUp = false;
    notifyListeners();
  }

  Future<bool> leaveUsersSetUp() {
    _isUsersSetUp = true;
    notifyListeners();
    return Future.value(true);
  }
}
