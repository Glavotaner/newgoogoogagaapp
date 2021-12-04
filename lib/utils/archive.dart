import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message/message.dart';
import 'package:googoogagaapp/models/message/message_repo.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:provider/provider.dart';

/// Saves a notifications message to shared preferences.
///
/// Saves [message] to shared preferences. If [context] is available, app is in the foreground and archive list is updated.
Future saveToArchive(Message message, [BuildContext? context]) async {
  final messages = await insertMessage('messages', message);
  if (context != null) {
    final archive = Provider.of<ArchiveManager>(context, listen: false);
    if (archive.isInitialized) {
      archive.updateMessages(messages);
    }
  }
}

/// Gets archived messages from shared preferences. Sets the archive list.
Future<void> getArchive(BuildContext context) async {
  final messages = await getMessages('messages');
  final archive = Provider.of<ArchiveManager>(context, listen: false);
  archive.updateMessages(messages);
  archive.isInitialized = true;
}

/// Clears the message archive in shared preferences, as well as the displayed archive list.
Future clearArchive(BuildContext context) async {
  await setMessages('messages', []);
  Provider.of<ArchiveManager>(context, listen: false).updateMessages([]);
  showConfirmSnackbar(context, 'Archive cleared!');
}
