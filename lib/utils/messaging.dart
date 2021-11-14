import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/archive.dart';
import 'package:googoogagaapp/utils/fcm.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Send kiss.
Future sendKiss(BuildContext context, KissType kissType,
    {Map<String, dynamic>? data}) async {
  final babyData =
      Provider.of<UsersManager>(context, listen: false).usersData[User.baby]!;
  await sendMessage(token: babyData.token, notification: {
    'title': kissType.title,
    'body': kissType.body,
  });
  final provider = Provider.of<AppStateManager>(context, listen: false);
  if (!provider.snackbarExists) {
    provider.snackbarExists = true;
    showConfirmSnackbar(context, kissType.confirmMessage)
        .closed
        .then((_) => provider.snackbarExists = false);
  }
}

Future sendQuickKiss(BuildContext context, double duration) async {
  await sendKiss(context, KissType.quickKiss, data: {'duration': duration});
}

Future sendRequest(BuildContext context, String message) async {
  sendKiss(context, KissType.kissRequest..body = message);
}

processMessage(BuildContext context, MessageModel message) async {
  if (message.hasData) {
    _processData(context, data: message.data);
  }
  if (message.isNotification) {
    saveToArchive(message, context);
    showAlert(
        context: context,
        body: message.body!,
        title: message.title,
        duration: 5);
  }
}

Future processMessageInBg(RemoteMessage remoteMessage) async {
  MessageModel message = MessageModel.fromRemote(remoteMessage);
  if (message.isNotification) {
    return saveToArchive(message);
  }
  if (message.isTokenRequest) {
    final babyData = await getUserData(user: User.baby);
    if (babyData.userName == message.data.userName) {
      return _saveMessageInBg(message, 'request');
    }
  } else if (message.data.token != null) {
    _saveMessageInBg(message, 'response');
  }
}

Future processBgMessages(BuildContext context) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final request = sharedPreferences.getString('request');
  final response = sharedPreferences.getString('response');
  if (response != null || request != null) {
    final users = Provider.of<UsersManager>(context, listen: false);
    String? token;
    if (response != null) {
      final MessageModel responseMessage =
          MessageModel.fromJson(jsonDecode(response));
      token = responseMessage.data.token;
      FirebaseMessaging.instance.unsubscribeFromTopic('tokens');
      showConfirmSnackbar(context, 'Saved babba token!');
    }
    if (request != null) {
      final userData = users.usersData[User.me]!;
      final MessageModel requestMessage =
          MessageModel.fromJson(jsonDecode(request));
      token ??= requestMessage.data.token;
      sendDataMessage(token: token, data: MessageData(token: userData.token));
      showConfirmSnackbar(context, 'Sending token to babby!');
    }
    final babyData = users.usersData[User.baby]!;
    setUserData(context, User.baby, babyData..token = token);
    users.updateUserNames(true, {User.baby: babyData..token = token});
    _clearBgMessages(sharedPreferences);
  }
}

_clearBgMessages(SharedPreferences sharedPreferences) async {
  sharedPreferences.remove('request');
  sharedPreferences.remove('response');
}

_processTokenMessage(
    {required BuildContext context, required MessageData data}) async {
  final users = Provider.of<UsersManager>(context, listen: false).usersData;
  final babyData = users[User.baby]!;
  setUserData(context, User.baby, babyData..token = data.token);
  if (data.tokenRequest != null) {
    if (data.userName == babyData.userName) {
      final userData = users[User.me]!;
      sendDataMessage(
          token: data.token, data: MessageData(token: userData.token));
      showConfirmSnackbar(context, 'Sending token to babby!');
    }
  } else if (data.token != null) {
    await Future.delayed(Duration(seconds: 2));
    FirebaseMessaging.instance.unsubscribeFromTopic('tokens');
    showConfirmSnackbar(context, 'Saved babba token!');
  }
}

Future _processData(BuildContext context, {required MessageData data}) async {
  if (data.tokenRequest == true || data.token != null) {
    _processTokenMessage(context: context, data: data);
  }
}

Future _saveMessageInBg(MessageModel message, String key) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString(key, message.toString());
}
