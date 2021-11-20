import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gets user data for [user] from shared preferences.
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

/// Sets [userData] for user [name] in shared preferences. Updates user data in user manager provider.
Future setUserData(BuildContext context, String name, User userData) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(name.toString(), userData.toString());
  Provider.of<UsersManager>(context, listen: false)
      .updateUserNames({name: userData});
}

/// Checks if any user's data is null. If so, navigates to users set up page.
/// This should only happen on first use of the app.
/// Otherwise stores user data from shared preferences in the users manager provider and navigates to home page.
Future<void> checkUsernamesSetUp(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  final state = Provider.of<AppStateManager>(context, listen: false);
  final users = Provider.of<UsersManager>(context, listen: false);
  final meData = await _checkUserExists(User.me);
  final babyData = await _checkUserExists(User.baby);
  if (meData != null && babyData != null && !state.isLoggedIn) {
    users.updateUserNames({User.me: meData, User.baby: babyData});
    return state.logIn();
  }
  state.finishLoading();
}

/// Checks whether any user in [usersData] is missing a token.
/// This is used to toggle the ability to send messages, or request tokens.
bool checkAnyTokenMissing(Map<String, User?> usersData) {
  for (User? user in usersData.values) {
    if (user?.token == null) {
      return true;
    }
  }
  return false;
}

/// Returns [user]'s data if it exists in shared preferences, otherwise returns null.
/// As opposed to [getUserData] which throws an exception if user data is null.
Future<User?> _checkUserExists(String user) async {
  try {
    return await getUserData(user: user);
  } catch (exception) {
    if (exception == "User data doesn't exist!") {
      return null;
    }
  }
}
