import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/quick_kiss/quick_kiss_alert.dart';
import 'package:googoogagaapp/components/quick_kiss/quick_kiss_list.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message/message.dart';
import 'package:googoogagaapp/models/message/message_repo.dart';
import 'package:googoogagaapp/services/services.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future sendQuickKiss(BuildContext context, double duration) async {
  await sendKiss(context,
      KissType.quickKiss..data = KissData(quickKissDuration: duration.toInt()));
}

Future<void> saveQuickKiss(
    Message message, SharedPreferences sharedPreferences) async {
  final kissesQueue = sharedPreferences.getStringList(Message.quickKiss);
  sharedPreferences
      .setStringList(Message.quickKiss, [message.toString(), ...?kissesQueue]);
}

Future processBgQuickKisses(BuildContext context, Messages kisses) async {
  final Messages validKisses = validQuickKisses(kisses);
  if (validKisses.isNotEmpty) {
    return showQuickKissModal(context, validKisses);
  }
  clearQuickKisses();
}

Future showQuickKissModal(BuildContext context, Messages validKisses) async {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => QuickKissListSheet(
          validKisses: validKisses, initialCount: validKisses.length),
      enableDrag: true);
}

Future<dynamic> showQuickKissAlert(Message quickKiss) async {
  final context = getScaffoldContext();
  await showDialog(
      context: context,
      builder: (_) =>
          QuickKissAlert(quickKiss.kissType!, parentContext: context));
  return _removeKissFromStorage(quickKiss.messageId);
}

Future processTappedQuickKiss(BuildContext context, Message kissMessage) async {
  final AlertsService alertsService = getService(ServicesEnum.alerts);
  try {
    alertsService.isHandlingTap = true;
    await _showQuickKissAlerts(context, kissMessage);
  } finally {
    alertsService.isHandlingTap = false;
  }
}

Future sendBaccAll(BuildContext context) async {}

clearQuickKisses() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove(Message.quickKiss);
}

bool quickKissIsValid(Message kiss) {
  final now = DateTime.now();
  final kissDuration = kiss.kissType!.data!.quickKissDuration!;
  final receiveTime = kiss.data.receiveTime!;
  final timeLeft = now.difference(receiveTime).inMinutes;
  kiss.kissType!.data!.timeLeft = timeLeft;
  return timeLeft < kissDuration;
}

Future<Map<String, dynamic>?> _getTappedMessage(String messageId) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final kisses = sharedPreferences.getStringList(Message.quickKiss);
  if (kisses != null) {
    final Messages kissMessages = kisses.map(Message.fromString).toList();
    final messageIndex =
        kissMessages.indexWhere((element) => element.messageId == messageId);
    if (messageIndex > -1) {
      final messageById = kissMessages.removeAt(messageIndex);
      return {
        'messages': validQuickKisses(kissMessages),
        'message': messageById
      };
    }
  }
}

Future<Messages> _getQuickKisses() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final kissesList = sharedPreferences.getStringList(Message.quickKiss);
  return kissesList?.map(Message.fromString).toList() ?? [];
}

Future _removeKissFromStorage(String messageId) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final quickKisses = await _getQuickKisses();
  final kissIndex =
      quickKisses.indexWhere((element) => element.messageId == messageId);
  if (kissIndex > -1) {
    quickKisses.removeAt(kissIndex);
  }
  sharedPreferences.setStringList(
      Message.quickKiss, quickKisses.map((e) => e.toString()).toList());
}

Future<void> _showQuickKissAlerts(BuildContext context, Message message) async {
  final kissesData = await _getTappedMessage(message.messageId);
  if (kissesData != null) {
    final Messages kisses = kissesData['messages'];
    final Message? kissInStorage = kissesData['message'];
    if (kissInStorage != null) {
      if (quickKissIsValid(kissInStorage)) {
        showQuickKissAlert(kissInStorage);
      }
    }
    if (kisses.length > 2) {
      return await showQuickKissModal(context, kisses);
    }
  } else {
    return await showErrorSnackbar("you didn't catched kiss in time");
  }
}
