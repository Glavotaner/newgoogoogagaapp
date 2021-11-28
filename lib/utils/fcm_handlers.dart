import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message/message.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:googoogagaapp/models/user/user_repo.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/archive.dart';
import 'package:googoogagaapp/utils/quick_kiss.dart';
import 'package:googoogagaapp/utils/tokens.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

onMessage(BuildContext context, RemoteMessage message) async {
  final remoteMessage = Message.fromRemote(message);
  if (remoteMessage.kissType == KissType.quickKiss) {
    showQuickKissAlert(context, remoteMessage);
  } else {
    _processMessageInForeground(context,
        (await SharedPreferences.getInstance()), Message.fromRemote(message));
  }
}

Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async {
  Message message = Message.fromRemote(remoteMessage);
  final sharedPreferences = await SharedPreferences.getInstance();
  if (message.isNotification) {
    await saveToArchive(message, sharedPreferences);
  }
  if (message.isTokenRequest) {
    final babyData = await getUser(User.baby);
    if (babyData.userName == message.data.userName) {
      return _saveMessage(message, Message.tokenRequest, sharedPreferences);
    }
  } else if (message.data.token != null) {
    return _saveMessage(message, Message.tokenResponse, sharedPreferences);
  }
  if (message.kissType != null) {
    final KissType kissType = message.kissType!;
    if (kissType == KissType.quickKiss) {
      saveQuickKiss(
          message..data.receiveTime = DateTime.now(), sharedPreferences);
    }
  }
}

Future<void> onTappedNotification(
    BuildContext context, RemoteMessage message) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.reload();
  final remoteMessage = Message.fromRemote(message);
  if (remoteMessage.kissType == KissType.quickKiss) {
    processTappedQuickKiss(context, remoteMessage);
  } else {
    _processMessageInForeground(context, sharedPreferences, remoteMessage);
  }
}

Future _saveMessage(
    Message message, String key, SharedPreferences sharedPreferences) async {
  sharedPreferences.setString(key, message.toString());
}

/// Process message while app in foreground and context
/// is available.
Future<void> _processMessageInForeground(BuildContext context,
    SharedPreferences sharedPreferences, Message message) async {
  if (message.hasData) {
    _processData(context, data: message.data);
  }
  if (message.isNotification) {
    saveToArchive(message, sharedPreferences);
    showAlert(
        context: context,
        body: message.body!,
        title: message.title,
        duration: 5);
  }
}

Future _processData(BuildContext context, {required MessageData data}) async {
  if (data.tokenRequest == true || data.token != null) {
    processTokenMessage(context: context, data: data);
  }
}
