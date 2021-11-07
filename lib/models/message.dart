import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

class Message {
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  Message({this.title, this.body, required this.data});

  static Message fromRemote(RemoteMessage remoteMessage) {
    return Message(
        data: remoteMessage.data,
        title: remoteMessage.notification?.title,
        body: remoteMessage.notification?.body);
  }

  @override
  String toString() {
    return '{ "title": "$title", "body": "$body", "data": ${jsonEncode(data)} }';
  }

  Message.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['body'],
        data = json['data'];

  Map<String, dynamic> toJson() => {'title': title, 'body': body, 'data': data};
}
