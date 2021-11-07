import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/models/user.dart';
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
}

Future sendQuickKiss(BuildContext context, double duration) async {
  await _sendMessage(
      token: Provider.of<UsersManager>(context, listen: false)
          .usersData[User.baby]!
          .token,
      notification: {
        'title': 'Quick kiss',
        'body': 'You gotted an quick kiss!'
      },
      data: {
        'duration': duration
      });
}

Future sendRequest(BuildContext context, String message) async {
  final kissType = KissType(
      body: message,
      title: 'Kiss request',
      confirmMessage: 'request sendededed');
  sendKiss(context, kissType);
}

Future sendDataMessage(
    {String? token, String? topic, required Map<String, dynamic> data}) async {
  return await _sendMessage(token: token, topic: topic, data: data);
}

processMessage(BuildContext context, RemoteMessage message) async {
  if (message.data.keys.isNotEmpty) {
    _processData(context, data: message.data);
  }
  if (message.notification != null) {
    saveToArchive(message, context);
    final notification = message.notification;
    showAlert(
        context: context,
        body: notification!.body!,
        title: notification.title,
        duration: 5);
  }
}

Future processMessageInBg(RemoteMessage remoteMessage) async {
  if (remoteMessage.notification != null) {
    return saveToArchive(remoteMessage);
  }
  if (remoteMessage.data.containsKey('tokenRequest')) {
    final babyData = await getUserData(user: User.baby);
    if (babyData.userName == remoteMessage.data['username']) {
      return _saveMessageInBg(remoteMessage, 'request');
    }
  } else if (remoteMessage.data.containsKey('token')) {
    _saveMessageInBg(remoteMessage, 'response');
  }
}

Future processBgMessages(BuildContext context) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final request = sharedPreferences.getString('request');
  final response = sharedPreferences.getString('response');
  if (response != null || request != null) {
    String? token;
    if (response != null) {
      final RemoteMessage remoteMessage = jsonDecode(response);
      token = remoteMessage.data['token'];
      FirebaseMessaging.instance.unsubscribeFromTopic('tokens');
      showConfirmSnackbar(context, 'Saved babba token!');
    }
    if (request != null) {
      final userData = await getUserData(user: User.me);
      final RemoteMessage remoteMessage = jsonDecode(request);
      token ??= remoteMessage.data['token'];
      sendDataMessage(token: token, data: {'token': userData.token});
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
    {required BuildContext context, required Map<String, dynamic> data}) async {
  final babyData = await getUserData(user: User.baby);
  if (data.containsKey('tokenRequest')) {
    if (data['username'] == babyData.userName) {
      final userData = await getUserData(user: User.me);
      sendDataMessage(token: data['token'], data: {'token': userData.token});
      showConfirmSnackbar(context, 'Sending token to babby!');
      setUserData(context, User.baby, babyData..token = data['token']);
    }
  } else if (data.containsKey('token')) {
    await Future.delayed(Duration(seconds: 2));
    setUserData(context, User.baby, babyData..token = data['token']);
    FirebaseMessaging.instance.unsubscribeFromTopic('tokens');
    showConfirmSnackbar(context, 'Saved babba token!');
  }
}

Future _processData(BuildContext context,
    {required Map<String, dynamic> data}) async {
  _processTokenMessage(context: context, data: data);
}

Future _saveMessageInBg(RemoteMessage remoteMessage, String key) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString(
      key, Message.fromRemote(remoteMessage).toString());
}

Future<Response> _sendMessage(
    {String? token,
    String? topic,
    Map<String, String>? notification,
    Map<String, dynamic>? data,
    String? collapseKey}) async {
  final fcmData = await getFCMData();
  Map<String, dynamic> requestBody = {
    "project_id": fcmData['projectId'],
    "to": token ?? '/topics/$topic'
  };
  requestBody['notification'] = notification;
  requestBody['data'] = data;
  requestBody['collapse_key'] = collapseKey;
  final serverKey = fcmData['serverKey'];
  return await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey'
      },
      body: jsonEncode(requestBody));
}
