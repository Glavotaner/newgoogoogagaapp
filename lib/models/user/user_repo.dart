import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User?> getUserIfExists(String user) async {
  try {
    return await getUser(user);
  } catch (exception) {
    if (exception.toString().contains('data missing for')) {
      return null;
    }
    rethrow;
  }
}

Future<User> getUser(String user) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final userData = sharedPreferences.getString(user);
  if (userData == null) {
    throw FlutterError('User data missing for $user!');
  }
  return User.fromString(userData);
}

Future<UsersData> getUsers() async {
  return {
    User.me: (await getUser(User.me)),
    User.baby: (await getUser(User.baby))
  };
}

Future<bool> updateUser(String user, User userData) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.setString(user, jsonEncode(userData));
}

Future<UsersData> updateUsers(User me, User baby) async {
  await Future.wait([updateUser(User.me, me), updateUser(User.baby, baby)]);
  return {User.me: me, User.baby: baby};
}

Future<bool> removeUser(String user) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.remove(user);
}
