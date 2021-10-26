import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googoogagaapp/screens/kiss_selection/models/kiss_type.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getFCMData() async {
  return jsonDecode((await rootBundle.loadString('assets/fcm.json')))['data'];
}

Future sendKiss(BuildContext context, KissType kissType,
    {Map<String, dynamic>? data}) async {
  final babyToken = await getUserToken('baby');
  await _sendMessage(babyToken!,
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

Future sendDataMessage(String to, Map<String, dynamic> data) async {
  _sendMessage(to, data: data);
}

processMessage(BuildContext context, RemoteMessage message) async {
  final data = message.data;
  if (data['customData'] != null) {
    _processData(context, data: data['customData']);
  }
  final notification = message.notification;
  if (notification != null) {
    showAlert(
        context: context, body: notification.body!, title: notification.title);
    Future.delayed(Duration(seconds: 2), () => Navigator.of(context).pop());
  }
}

Future processMessageInBg(RemoteMessage remoteMessage) async {
  final topic = remoteMessage.from;
  if (topic?.isNotEmpty ?? false) {
    if (topic == 'tokens') {
      if (remoteMessage.data['tokenRequest'] != null) {
        final babyData = await getUserData(user: 'baby');
        if (babyData.userName == remoteMessage.data['username']) {
          return _saveMessageInBg(remoteMessage, 'request');
        }
      }
    }
    if (remoteMessage.data['token']) {
      _saveMessageInBg(remoteMessage, 'response');
    }
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
    }
    if (request != null) {
      final userData = await getUserData(user: 'me');
      final RemoteMessage remoteMessage = jsonDecode(request);
      token ??= remoteMessage.data['token'];
      sendDataMessage(token!, {'token': userData.token});
      showConfirmSnackbar(context, 'Sending token to babby!');
    }
    final babyData = await getUserData(user: 'baby');
    setUserData('baby', babyData..token = token);
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
  if (data['tokenRequest'] ?? false) {
    final userData = await getUserData(user: 'me');
    if (data['username'] == babyData.userName) {
      sendDataMessage(data['token'], {'token': userData.token});
      showConfirmSnackbar(context, 'Sending token to babby!');
      setUserData('baby', babyData..token = data['token']);
    }
  } else if (data['token'] != null) {
    setUserData('baby', babyData..token = data['token']);
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
  sharedPreferences.setString(key, jsonEncode(remoteMessage));
}

Future<Response> _sendMessage(String to,
    {Map<String, String>? notification, Map<String, dynamic>? data}) async {
  final fcmData = await getFCMData();
  Map<String, dynamic> requestBody = {
    "project_id": fcmData['projectId'],
    "to": to
  };
  if (notification != null) {
    requestBody['notification'] = notification;
  }
  if (data != null) {
    requestBody['data'] = data;
  }
  return await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$fcmData["serverKey"]'
      },
      body: jsonEncode(requestBody));
}
