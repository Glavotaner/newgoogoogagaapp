import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
