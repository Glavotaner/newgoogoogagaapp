import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';

class ArchiveManager extends ChangeNotifier {
  List<MessageModel> _messages = [];
  bool _initialized = false;
  List<MessageModel> get messages => _messages;
  bool get isInitialized => _initialized;

  updateMessages(List<MessageModel> messages) {
    _messages = messages;
    notifyListeners();
  }

  initialize() {
    _initialized = true;
  }
}
