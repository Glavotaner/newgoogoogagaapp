import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googoogagaapp/screens/kiss_selection/models/kiss_type.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/tokens.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getFCMData() async {
  return jsonDecode((await rootBundle.loadString('assets/fcm.json')))['data'];
}

Future sendKiss(BuildContext context, KissType kissType,
    {Map<String, dynamic>? data}) async {
  final babyToken = await getToken('baby');
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

processMessage(BuildContext context, RemoteMessage message) {
  final notification = message.notification;
  // TODO implement handling data
  final data = message.data;
  if (data['quickKissRequest'] != null) {
    // TODO implement quick kiss
  }
  if (notification != null) {
    showAlert(
        context: context, body: notification.body!, title: notification.title);
    Future.delayed(Duration(seconds: 2), () => Navigator.of(context).pop());
  }
}

Future saveMessageInBg(RemoteMessage remoteMessage) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  List<String>? messages = sharedPreferences.getStringList('messages') ?? [];
  Map<String, dynamic> message = {
    'data': remoteMessage.data,
    'notification': remoteMessage.notification
  };
  messages.add(jsonEncode(message));
  sharedPreferences.setStringList('messages', messages);
}

Future<Response> _sendMessage(String token,
    {Map<String, String>? notification, Map<String, dynamic>? data}) async {
  final fcmData = await getFCMData();
  Map<String, dynamic> requestBody = {
    "project_id": fcmData['projectId'],
    "to": token
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
