import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googoogagaapp/models/kiss_type.dart';

class Message {
  final String messageId;
  final MessageData data;
  final String? title;
  final String? body;
  final KissType? kissType;

  static final tokenRequest = 'request';
  static final tokenResponse = 'response';
  static final quickKiss = 'quickKiss';

  bool get isNotification =>
      (title ?? '').isNotEmpty || (body ?? '').isNotEmpty;

  Message(
      {required this.messageId,
      required this.data,
      this.title,
      this.body,
      this.kissType});

  Message.fromRemote(RemoteMessage remoteMessage)
      : messageId = remoteMessage.messageId!,
        data = MessageData.fromJson(
            jsonDecode(remoteMessage.data['customData'] ?? '{}')),
        title = remoteMessage.notification?.title,
        body = remoteMessage.notification?.body,
        kissType = remoteMessage.data.containsKey('kissType')
            ? KissType.fromJson(jsonDecode(remoteMessage.data['kissType']))
            : null;

  Message.fromJson(Map<String, dynamic> json)
      : messageId = json['messageId'],
        title = json['title'],
        body = json['body'],
        data = MessageData.fromJson(json['data'] ?? {}),
        kissType = json.containsKey('kissType')
            ? KissType.fromJson(json['kissType'])
            : null;

  static Message fromString(String string) =>
      Message.fromJson(jsonDecode(string));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    final jsonMessage = {
      'messageId': messageId,
      'title': title,
      'body': body,
      'data': data.toJson(),
      'kissType': kissType?.toJson()
    };
    jsonMessage.removeWhere((_, value) => value == null);
    return jsonMessage;
  }

  bool get hasData => data.toJson().isNotEmpty;
}

class MessageData {
  DateTime? receiveTime;
  String? token;
  String? userName;
  bool? tokenRequest;

  MessageData({
    this.receiveTime,
    this.token,
    this.userName,
    this.tokenRequest,
  });

  MessageData.fromRemote(RemoteMessage remoteMessage) {
    var data = remoteMessage.data['customData'];
    if (data != null) {
      data = jsonDecode(data);
    }
    receiveTime = data?['receiveTime'] != null
        ? DateTime.tryParse(data['receiveTime'])
        : null;
    token = data?['token'];
    userName = data?['userName'];
    tokenRequest = data['tokenRequest'] ?? false;
  }

  MessageData.fromJson(Map<String, dynamic> json)
      : receiveTime = json['receiveTime'] != null
            ? DateTime.tryParse(json['receiveTime'])
            : null,
        userName = json['userName'],
        token = json['token'],
        tokenRequest = json['tokenRequest'];

  Map<String, dynamic> toJson() => {
        'receiveTime': receiveTime?.toIso8601String(),
        'token': token,
        'userName': userName,
        'tokenRequest': tokenRequest,
      };

  bool get isNotEmpty => toJson().isNotEmpty;
}

typedef Messages = List<Message>;
