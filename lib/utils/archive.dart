import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future saveToArchive(RemoteMessage remoteMessage,
    [BuildContext? context]) async {
  if (!remoteMessage.from!.contains('tokens')) {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var currentList = sharedPreferences.getStringList('messages') ?? [];
    final stringMessage = Message(
            data: remoteMessage.data,
            title: remoteMessage.notification?.title,
            body: remoteMessage.notification?.body)
        .toString();
    var additionalList = [stringMessage];
    additionalList.addAll(currentList);
    sharedPreferences.setStringList('messages', additionalList);
    if (context != null) {
      final archive = Provider.of<ArchiveManager>(context, listen: false);
      if (archive.isInitialized) {
        archive.updateMessages(additionalList
            .map((message) => Message.fromJson(jsonDecode(message)))
            .toList());
      }
    }
  }
}

Future<List<Message>?> getArchive(BuildContext context) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final messages = sharedPreferences
          .getStringList('messages')
          ?.map((message) => Message.fromJson(jsonDecode(message)))
          .toList() ??
      [];
  final archive = Provider.of<ArchiveManager>(context, listen: false);
  archive.updateMessages(messages);
  archive.initialize();
}

Future clearArchive(BuildContext context) async {
  (await SharedPreferences.getInstance()).remove('messages');
  Provider.of<ArchiveManager>(context, listen: false).updateMessages([]);
  showConfirmSnackbar(context, 'Archive cleared!');
}
