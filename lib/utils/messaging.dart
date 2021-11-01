import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getFCMData() async {
  return jsonDecode((await rootBundle.loadString('assets/fcm.json')))['data'];
}

Future sendKiss(BuildContext context, KissType kissType,
    {Map<String, dynamic>? data}) async {
  final babyData = await getUserData(user: 'baby');
  if (!babyData.hasToken) {
    showErrorSnackbar(context, 'Baby token missing!');
    throw ErrorDescription('Token missing');
  }
  await _sendMessage(
      token: babyData.token,
      notification: {'title': kissType.title, 'body': kissType.body});
  showConfirmSnackbar(context, kissType.confirmMessage);
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
    final notification = message.notification;
    showAlert(
        context: context,
        body: notification!.body!,
        title: notification.title,
        duration: 5);
  }
}

Future processMessageInBg(RemoteMessage remoteMessage) async {
  if (remoteMessage.data.containsKey('tokenRequest')) {
    final babyData = await getUserData(user: 'baby');
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
      final userData = await getUserData(user: 'me');
      final RemoteMessage remoteMessage = jsonDecode(request);
      token ??= remoteMessage.data['token'];
      sendDataMessage(token: token, data: {'token': userData.token});
      showConfirmSnackbar(context, 'Sending token to babby!');
    }
    final babyData = await getUserData(user: 'baby');
    setUserData(context, 'baby', babyData..token = token);
    Provider.of<AppStateManager>(context, listen: false)
        .setUpUserNames(true, {'baby': babyData..token = token});
    _clearBgMessages(sharedPreferences);
  }
}

_clearBgMessages(SharedPreferences sharedPreferences) async {
  sharedPreferences.remove('request');
  sharedPreferences.remove('response');
}

_processTokenMessage(
    {required BuildContext context, required Map<String, dynamic> data}) async {
  final babyData = await getUserData(user: 'baby');
  if (data.containsKey('tokenRequest')) {
    if (data['username'] == babyData.userName) {
      final userData = await getUserData(user: 'me');
      sendDataMessage(token: data['token'], data: {'token': userData.token});
      showConfirmSnackbar(context, 'Sending token to babby!');
      setUserData(context, 'baby', babyData..token = data['token']);
    }
  } else if (data.containsKey('token')) {
    await Future.delayed(Duration(seconds: 2));
    setUserData(context, 'baby', babyData..token = data['token']);
    FirebaseMessaging.instance.unsubscribeFromTopic('tokens');
    showConfirmSnackbar(context, 'Saved babba token!');
  }
}

Future _processData(BuildContext context,
    {required Map<String, dynamic> data}) async {
  // TODO implement process data
  _processTokenMessage(context: context, data: data);
}

Future _saveMessageInBg(RemoteMessage remoteMessage, String key) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString(key, jsonEncode(remoteMessage.toString()));
}

Future<Response> _sendMessage(
    {String? token,
    String? topic,
    Map<String, String>? notification,
    Map<String, dynamic>? data}) async {
  final fcmData = await getFCMData();
  Map<String, dynamic> requestBody = {
    "project_id": fcmData['projectId'],
    "to": token ?? '/topics/$topic'
  };
  requestBody['notification'] = notification;
  requestBody['data'] = data;
  final serverKey = fcmData['serverKey'];
  return await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey'
      },
      body: jsonEncode(requestBody));
}
