import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googoogagaapp/screens/kiss_selection/models/kiss_type.dart';
import 'package:googoogagaapp/utils/tokens.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> getFCMData() async {
  return jsonDecode(await rootBundle.loadString('/assets/fcm.json'))['data'];
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

showConfirmSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)));
}

showMessageAlert(BuildContext context,
    {String? title, required String body, Map<String, dynamic>? extras}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title != null && title.isNotEmpty ? Text(title) : null,
          content: Text(body),
        );
      });
  Future.delayed(Duration(seconds: 2), () => Navigator.of(context).pop());
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
