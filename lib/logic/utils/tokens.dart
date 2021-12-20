import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googoogagaapp/logic/providers/users_manager.dart';
import 'package:googoogagaapp/logic/utils/alerts.dart';
import 'package:googoogagaapp/logic/utils/fcm.dart';
import 'package:googoogagaapp/logic/utils/messaging.dart';
import 'package:googoogagaapp/logic/utils/user_data.dart';
import 'package:googoogagaapp/models/message/message.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String processBgTokenRequest(
    BuildContext context, Message request, UsersManager usersManager) {
  final user = usersManager.usersData[User.me]!;
  String token = request.data.token!;
  sendDataMessage(token: token, data: MessageData(token: user.token));
  showConfirmSnackbar('Sending token to babby!');
  return token;
}

String processBgTokenResponse(BuildContext context, Message response) {
  FirebaseMessaging.instance.unsubscribeFromTopic('tokens');
  showConfirmSnackbar('Saved babba token!');
  return response.data.token!;
}

Future<void> saveReceivedToken(
    BuildContext context, String token, UsersManager manager) async {
  final babyData = manager.usersData[User.baby]!;
  updateUserData(context, User.baby, babyData..token = token);
  clearSearchingForToken();
  clearTokenMessages();
}

processTokenMessage(
    {required BuildContext context, required MessageData data}) async {
  final users = Provider.of<UsersManager>(context, listen: false).usersData;
  final babyData = users[User.baby]!;
  if (data.tokenRequest != null) {
    if (data.userName == babyData.userName) {
      updateUserData(context, User.baby, babyData..token = data.token);
      final userData = users[User.me]!;
      sendDataMessage(
          token: data.token, data: MessageData(token: userData.token));
      showConfirmSnackbar('Sending token to babby!');
    }
  } else if (data.token != null) {
    updateUserData(context, User.baby, babyData..token = data.token);
    FirebaseMessaging.instance.unsubscribeFromTopic('tokens');
    clearSearchingForToken(context);
    showConfirmSnackbar('Saved babba token!');
  }
}

Future<bool> checkIsWaitingForToken() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  return sharedPreferences.getBool(User.searchingForToken) ?? false;
}

Future setSearchingForToken([BuildContext? context]) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await sharedPreferences.setBool(User.searchingForToken, true);
  if (context != null) {
    Provider.of<UsersManager>(context, listen: false).startSearchingForToken();
  }
}

Future clearSearchingForToken([BuildContext? context]) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await sharedPreferences.setBool(User.searchingForToken, false);
  if (context != null) {
    Provider.of<UsersManager>(context, listen: false).stopSearchingForToken();
  }
}
