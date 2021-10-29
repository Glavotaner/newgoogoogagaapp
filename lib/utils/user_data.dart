import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> getUserData({BuildContext? context, required String user}) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final userData = sharedPreferences.getString(user);
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
  sharedPreferences.setString(name, jsonEncode(userData.toJson()));
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

Future<Map<String, User?>> checkUsernamesSetUp() async {
  final meData = await _checkUserExists('me');
  final babyData = await _checkUserExists('baby');
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
