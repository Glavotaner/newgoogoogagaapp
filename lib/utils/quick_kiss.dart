import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future sendQuickKiss(BuildContext context, double duration) async {
  await sendKiss(
      context,
      KissType.quickKiss
        ..kissData = KissTypeData(quickKissDuration: duration.toInt()));
}

Future<void> saveQuickKissInBg(MessageModel message) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final kissesQueue = sharedPreferences.getStringList(MessageModel.quickKiss);
  await sharedPreferences.setStringList(
      MessageModel.quickKiss, [message.toString(), ...?kissesQueue]);
}

Future processBgQuickKisses(BuildContext context, Messages kisses) async {
  final Messages validKisses = kisses.where(quickKissIsValid).toList();
  while (validKisses.isNotEmpty) {
    validKisses.removeAt(0);
    _updateQuickKisses(validKisses);
    await showQuickKissAlert(context);
  }
  _clearQuickKisses();
}

Future<dynamic> showQuickKissAlert(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (BuildContext diagContext) {
        return AlertDialog(
          title: Text(KissType.quickKiss.title),
          content: Text(KissType.quickKiss.body),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton.icon(
                onPressed: () => _sendKissBack(context, diagContext),
                icon: Icon(Icons.favorite),
                label: Text('send kiss baccc'))
          ],
        );
      });
}

Future processTappedQuickKiss(
    BuildContext context, MessageModel kissMessage) async {
  final appState = Provider.of<AppStateManager>(context, listen: false);
  try {
    appState.handleQuickKissTap(true);
    final kissesData = await _getMessageById(kissMessage.messageId);
    if (kissesData != null) {
      final kissInStorage = kissesData['message'];
      if (kissInStorage != null) {
        if (quickKissIsValid(kissInStorage)) {
          return Future.wait([
            _updateQuickKisses(kissesData['messages']),
            showQuickKissAlert(context)
          ]);
        }
      }
    }
    showErrorSnackbar(context, "you didn't catched kiss in time");
  } finally {
    appState.handleQuickKissTap(false);
  }
}

Future processQuickKissesAfterTap(BuildContext context) async {}

Future _updateQuickKisses(Messages kisses) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setStringList(
      MessageModel.quickKiss, kisses.map((e) => e.toString()).toList());
}

_clearQuickKisses() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove(MessageModel.quickKiss);
}

_sendKissBack(BuildContext context, BuildContext diagContext) {
  sendKiss(context, KissType.kissBack);
  Navigator.of(diagContext, rootNavigator: true).pop(true);
}

Future<Map<String, dynamic>?> _getMessageById(String messageId) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final kisses = sharedPreferences.getStringList(MessageModel.quickKiss);
  if (kisses != null) {
    final Messages kissMessages =
        kisses.map((e) => MessageModel.fromJson(jsonDecode(e))).toList();
    final messageIndex =
        kissMessages.indexWhere((element) => element.messageId == messageId);
    if (messageIndex > -1) {
      final messageById = kissMessages.removeAt(messageIndex);
      return {'messages': kissMessages, 'message': messageById};
    }
  }
}

bool quickKissIsValid(MessageModel kiss) {
  final now = DateTime.now();
  final kissDuration = kiss.data.kissType!.kissData!.quickKissDuration!;
  final receiveTime = kiss.data.receiveTime!;
  return now.difference(receiveTime).inMinutes < kissDuration;
}
