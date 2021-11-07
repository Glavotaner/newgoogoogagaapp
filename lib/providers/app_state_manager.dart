import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  bool _userNamesSetUp = false;
  bool _loading = true;
  bool _loggedIn = false;
  bool _takingPhoto = false;

  bool get isUserNamesSetUp => _userNamesSetUp;
  bool get isLoading => _loading;
  bool get isLoggedIn => _loggedIn;
  bool get isTakingPhoto => _takingPhoto;

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

  takingPhoto(bool taking) {
    _takingPhoto = taking;
    notifyListeners();
    return Future.value(true);
  }
}
