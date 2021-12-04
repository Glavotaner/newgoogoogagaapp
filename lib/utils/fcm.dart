import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message/message.dart';
import 'package:http/http.dart';

/// Get FCM data from assets.
/// Used for sending messages.
Future<Map<String, dynamic>> getFCMData() async {
  return jsonDecode((await rootBundle.loadString('assets/fcm.json')))['data'];
}

/// Sends FCM message.
///
/// If [token] is passed, sends message to token. Otherwise sends message to [topic]. '/topics' prefix is not necessary.
/// Allows for optional sending of [data] or [notification] message or both.
Future<Response> sendMessage(
    {String? token,
    String? topic,
    Map<String, String>? notification,
    MessageData? data,
    KissType? kissType}) async {
  final fcmData = await getFCMData();
  Map<String, dynamic> requestBody = {
    "project_id": fcmData['projectId'],
    "to": token ?? '/topics/$topic'
  };
  requestBody['notification'] = notification;
  requestBody['data'] = {'customData': data?.toJson(), 'kissType': kissType};
  requestBody.removeWhere((_, value) => value == null);
  return await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=${fcmData['serverKey']}'
      },
      body: jsonEncode(requestBody));
}

/// Sends data only FCM message to [token] or [topic].
Future sendDataMessage(
    {String? token, String? topic, required MessageData data}) async {
  return await sendMessage(token: token, topic: topic, data: data);
}
