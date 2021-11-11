import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> getUserData({BuildContext? context, required String user}) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final userData = sharedPreferences.getString(user.toString());
  if (userData?.isNotEmpty ?? false) {
    return User.fromJson(jsonDecode(userData!));
  } else {
    final errorMessage = "User data doesn't exist!";
    if (context != null) {
      showErrorSnackbar(context, errorMessage);
    }
    throw ErrorDescription(errorMessage);
  }
}

Future setUserData(BuildContext context, String name, User userData) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(name.toString(), jsonEncode(userData.toJson()));
  Provider.of<UsersManager>(context, listen: false)
      .updateUpUserNames(true, {name: userData});
}

Future<void> checkUsernamesSetUp(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  final state = Provider.of<AppStateManager>(context, listen: false);
  final users = Provider.of<UsersManager>(context, listen: false);
  final meData = await _checkUserExists(User.me);
  final babyData = await _checkUserExists(User.baby);
  if (meData != null && babyData != null && !state.isLoggedIn) {
    users.updateUpUserNames(true, {User.me: meData, User.baby: babyData});
    return state.logIn();
  }
  state.finishLoading();
}

bool checkAnyTokenMissing(Map<String, User?> usersData) {
  for (User? user in usersData.values) {
    if (user?.token == null) {
      return true;
    }
  }
  return false;
}

Future<User?> _checkUserExists(String user) async {
  try {
    return await getUserData(user: user);
  } catch (exception) {
    if (exception == "User data doesn't exist!") {
      return null;
    }
  }
}
