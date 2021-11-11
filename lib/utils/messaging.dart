import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/archive.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Get FCM data from assets.
/// Used for sending messages.
Future<Map<String, dynamic>> getFCMData() async {
  return jsonDecode((await rootBundle.loadString('assets/fcm.json')))['data'];
}

/// Send kiss.
Future sendKiss(BuildContext context, KissType kissType,
    {Map<String, dynamic>? data}) async {
  final babyData = await getUserData(user: User.baby);
  await _sendMessage(
      token: babyData.token,
      notification: {
        'title': kissType.title,
        'body': kissType.body,
        'tag': 'kiss'
      },
      collapseKey: 'kiss');
  final provider = Provider.of<AppStateManager>(context, listen: false);
  if (!provider.snackbarExists) {
    provider.setSnackbarExists(true);
    showConfirmSnackbar(context, kissType.confirmMessage)
        .closed
        .then((_) => provider.setSnackbarExists(false));
  }
}

Future sendQuickKiss(BuildContext context, double duration) async {
  final kissType = KissType.quickKiss;
  await sendKiss(context, kissType);
}

Future sendRequest(BuildContext context, String message) async {
  sendKiss(context, KissType.kissRequest..body = message);
}

Future sendDataMessage(
    {String? token, String? topic, required MessageData data}) async {
  return await _sendMessage(token: token, topic: topic, data: data);
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
    String? token;
    if (response != null) {
      final MessageModel responseMessage =
          MessageModel.fromJson(jsonDecode(response));
      token = responseMessage.data.token;
      FirebaseMessaging.instance.unsubscribeFromTopic('tokens');
      showConfirmSnackbar(context, 'Saved babba token!');
    }
    if (request != null) {
      final userData = await getUserData(user: User.me);
      final MessageModel requestMessage =
          MessageModel.fromJson(jsonDecode(request));
      token ??= requestMessage.data.token;
      sendDataMessage(token: token, data: MessageData(token: userData.token));
      showConfirmSnackbar(context, 'Sending token to babby!');
    }
    final babyData = await getUserData(user: User.baby);
    setUserData(context, User.baby, babyData..token = token);
    Provider.of<UsersManager>(context, listen: false)
        .updateUpUserNames(true, {User.baby: babyData..token = token});
    _clearBgMessages(sharedPreferences);
  }
}

_clearBgMessages(SharedPreferences sharedPreferences) async {
  sharedPreferences.remove('request');
  sharedPreferences.remove('response');
}

_processTokenMessage(
    {required BuildContext context, required MessageData data}) async {
  final babyData = await getUserData(user: User.baby);
  if (data.tokenRequest != null) {
    if (data.userName == babyData.userName) {
      final userData = await getUserData(user: User.me);
      sendDataMessage(
          token: data.token, data: MessageData(token: userData.token));
      showConfirmSnackbar(context, 'Sending token to babby!');
      setUserData(context, User.baby, babyData..token = data.token);
    }
  } else if (data.token != null) {
    await Future.delayed(Duration(seconds: 2));
    setUserData(context, User.baby, babyData..token = data.token);
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

Future<Response> _sendMessage(
    {String? token,
    String? topic,
    Map<String, String>? notification,
    MessageData? data,
    String? collapseKey}) async {
  final fcmData = await getFCMData();
  Map<String, dynamic> requestBody = {
    "project_id": fcmData['projectId'],
    "to": token ?? '/topics/$topic'
  };
  requestBody['notification'] = notification;
  requestBody['data'] = data?.toJson();
  requestBody['collapse_key'] = collapseKey;
  final serverKey = fcmData['serverKey'];
  return await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey'
      },
      body: jsonEncode(requestBody));
}
