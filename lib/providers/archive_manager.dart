import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';

class ArchiveManager extends ChangeNotifier {
  List<Message> _messages = [];
  bool _initialized = false;
  List<Message> get messages => _messages;
  bool get isInitialized => _initialized;

  updateMessages(List<Message> messages) {
    _messages = messages;
    notifyListeners();
  }

  initialize() {
    _initialized = true;
  }
}
