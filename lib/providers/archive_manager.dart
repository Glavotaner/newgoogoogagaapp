import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message/message.dart';

class ArchiveManager extends ChangeNotifier {
  Messages _messages = [];
  bool isInitialized = false;

  Messages get messages => _messages;

  updateArchive(Messages messages) {
    _messages = messages;
    isInitialized = true;
    notifyListeners();
  }
}
