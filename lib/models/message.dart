import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googoogagaapp/models/kiss_type.dart';

class MessageModel {
  final String messageId;
  final String? title;
  final String? body;
  final MessageData data;

  bool get hasData => data.toJson().values.any((value) => value != null);
  bool get isNotification =>
      (title ?? '').isNotEmpty || (body ?? '').isNotEmpty;
  bool get isTokenRequest => data.tokenRequest != null;

  MessageModel(
      {this.title, this.body, required this.messageId, required this.data});

  MessageModel.fromRemote(RemoteMessage remoteMessage)
      : messageId = remoteMessage.messageId!,
        data = MessageData.fromRemote(remoteMessage),
        title = remoteMessage.notification?.title,
        body = remoteMessage.notification?.body;

  MessageModel.fromJson(Map<String, dynamic> json)
      : messageId = json['messageId'],
        title = json['title'],
        body = json['body'],
        data = MessageData.fromJson(json['data']);

  @override
  String toString() {
    return '{ "messageId": "$messageId" "title": "$title", "body": "$body", "data": ${jsonEncode(data.toJson())} }';
  }

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'title': title,
        'body': body,
        'data': data.toJson()
      };
}

class MessageData {
  DateTime? receiveTime;
  String? token;
  String? userName;
  bool? tokenRequest;
  KissType? kissType;

  MessageData(
      {this.receiveTime,
      this.token,
      this.userName,
      this.tokenRequest,
      this.kissType});

  MessageData.fromRemote(RemoteMessage remoteMessage) {
    final data = remoteMessage.data;
    if (data.isNotEmpty) {
      receiveTime = DateTime.tryParse(data['receiveTime']);
      token = data['token'];
      userName = data['userName'];
      tokenRequest = data['tokenRequest'];
      kissType =
          data['kissType'] != null ? KissType.fromJson(data['kissType']) : null;
    }
  }

  MessageData.fromJson(Map<String, dynamic> json)
      : receiveTime = DateTime.tryParse(json['receiveTime']),
        userName = json['userName'],
        token = json['token'],
        tokenRequest = json['tokenRequest'],
        kissType = json['kissType'] != null
            ? KissType.fromJson(json['kissType'])
            : null;

  Map<String, dynamic> toJson() => {
        'receiveTime': receiveTime?.toIso8601String(),
        'token': token,
        'userName': userName,
        'tokenRequest': tokenRequest,
        'kissType': kissType?.toJson()
      };
}
