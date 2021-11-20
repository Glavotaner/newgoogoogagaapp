import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';

class ArchiveManager extends ChangeNotifier {
  Messages _messages = [];
  bool isInitialized = false;

  Messages get messages => _messages;

  updateMessages(Messages messages) {
    _messages = messages;
    notifyListeners();
  }
}
