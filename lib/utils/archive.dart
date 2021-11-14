import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Saves a notifications message to shared preferences.
///
/// Saves [message] to shared preferences. If [context] is available, app is in the foreground and archive list is updated.
Future saveToArchive(MessageModel message, [BuildContext? context]) async {
  if (!message.isTokenRequest) {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var currentList = sharedPreferences.getStringList('messages') ?? [];
    final stringMessage = message.toString();
    var additionalList = [stringMessage];
    additionalList.addAll(currentList);
    sharedPreferences.setStringList('messages', additionalList);
    if (context != null) {
      final archive = Provider.of<ArchiveManager>(context, listen: false);
      if (archive.isInitialized) {
        archive.updateMessages(additionalList
            .map((message) => MessageModel.fromJson(jsonDecode(message)))
            .toList());
      }
    }
  }
}

/// Gets archived messages from shared preferences. Sets the archive list.
Future<void> getArchive(BuildContext context) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final messages = sharedPreferences
          .getStringList('messages')
          ?.map((message) => MessageModel.fromJson(jsonDecode(message)))
          .toList() ??
      [];
  final archive = Provider.of<ArchiveManager>(context, listen: false);
  archive.updateMessages(messages);
  archive.isInitialized = true;
}

/// Clears the message archive in shared preferences, as well as the displayed archive list.
Future clearArchive(BuildContext context) async {
  (await SharedPreferences.getInstance()).remove('messages');
  Provider.of<ArchiveManager>(context, listen: false).updateMessages([]);
  showConfirmSnackbar(context, 'Archive cleared!');
}
