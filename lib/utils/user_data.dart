import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
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

Future setUserData(String name, User userData) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(name.toString(), jsonEncode(userData.toJson()));
}

Future setUserToken(
    {BuildContext? context,
    required String user,
    required String token}) async {
  setUserData(
      user,
      (await getUserData(user: user)
        ..token = token));
}

Future<Map<String, User?>> checkUsernamesSetUp(BuildContext context) async {
  final provider = Provider.of<AppStateManager>(context, listen: false);
  final meData = await _checkUserExists('me');
  final babyData = await _checkUserExists('baby');
  if (meData != null && babyData != null && !provider.isinitialized) {
    provider.setUpUserNames(true, {'me': meData, 'baby': babyData});
  }
  provider.finishLoading();
  return {'me': meData, 'baby': babyData};
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
