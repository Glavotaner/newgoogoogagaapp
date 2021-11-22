import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/quick_kiss_alert.dart';
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

Future<void> saveQuickKissInBg(
    MessageModel message, SharedPreferences sharedPreferences) async {
  final kissesQueue = sharedPreferences.getStringList(MessageModel.quickKiss);
  sharedPreferences.setStringList(
      MessageModel.quickKiss, [message.toString(), ...?kissesQueue]);
}

Future processBgQuickKisses(BuildContext context, Messages kisses) async {
  final List<Map> validKisses = KissType.validQuickKisses(kisses);
  Map? kiss;
  while (validKisses.isNotEmpty) {
    if (kiss != null) {
      await Future.delayed(Duration(milliseconds: 500));
    }
    kiss = validKisses.removeAt(0);
    MessageModel message = kiss['message'];
    var quickKiss = message.data.kissType!
      ..kissData!.quickKissDuration = kiss['timeLeft'];
    _updateQuickKisses(
        validKisses.map((e) => e['message'] as MessageModel).toList());
    await showQuickKissAlert(context, quickKiss);
  }

  _clearQuickKisses();
}

Future<dynamic> showQuickKissAlert(
    BuildContext context, KissType quickKiss) async {
  return showDialog(
      context: context,
      builder: (_) => QuickKissAlert(quickKiss, parentContext: context));
}

Future processTappedQuickKiss(
    BuildContext context, MessageModel kissMessage) async {
  final appState = Provider.of<AppStateManager>(context, listen: false);
  try {
    appState.handleQuickKissTap(true);
    final kissesData = await _getMessageById(kissMessage.messageId);
    if (kissesData != null) {
      final MessageModel? kissInStorage = kissesData['message'];
      if (kissInStorage != null) {
        if (quickKissIsValid(kissInStorage)) {
          return Future.wait([
            _updateQuickKisses(kissesData['messages']),
            showQuickKissAlert(context, kissInStorage.data.kissType!)
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

Future<Map<String, dynamic>?> _getMessageById(String messageId) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.reload();
  final kisses = sharedPreferences.getStringList(MessageModel.quickKiss);
  if (kisses != null) {
    final Messages kissMessages = kisses.map(MessageModel.fromString).toList();
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
