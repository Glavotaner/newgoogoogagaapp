import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';

class ArchiveManager extends ChangeNotifier {
  List<MessageModel> _messages = [];
  bool isInitialized = false;

  List<MessageModel> get messages => _messages;

  updateMessages(List<MessageModel> messages) {
    _messages = messages;
    notifyListeners();
  }

}
