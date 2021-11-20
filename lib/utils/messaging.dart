import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/archive.dart';
import 'package:googoogagaapp/utils/fcm.dart';
import 'package:googoogagaapp/utils/quick_kiss.dart';
import 'package:googoogagaapp/utils/tokens.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future sendKiss(BuildContext context, KissType kissType,
    {Map<String, dynamic>? data}) async {
  final babyData =
      Provider.of<UsersManager>(context, listen: false).usersData[User.baby]!;
  await sendMessage(
      token: babyData.token,
      notification: {
        'title': kissType.title,
        'body': kissType.body,
      },
      data: kissType.isQuickKiss ? MessageData(kissType: kissType) : null);
  final provider = Provider.of<AppStateManager>(context, listen: false);
  if (!provider.snackbarExists) {
    provider.snackbarExists = true;
    showConfirmSnackbar(context, kissType.confirmMessage)
        .closed
        .then((_) => provider.snackbarExists = false);
  }
}

Future sendRequest(BuildContext context, String message) async {
  sendKiss(context, KissType.kissRequest..body = message);
}

/// Process message while app in foreground and context
/// is available.
Future<void> processMessageInForeground(
    BuildContext context, MessageModel message) async {
  if (message.hasData) {
    _processData(context, data: message.data);
  }
  if (message.isNotification) {
    saveToArchive(message, context);
    showAlert(
        context: context,
        body: message.body!,
        title: message.title,
        duration: 5);
  }
}

Future<void> processMessageInBackground(RemoteMessage remoteMessage) async {
  MessageModel message = MessageModel.fromRemote(remoteMessage);
  if (message.isNotification) {
    return saveToArchive(message);
  }
  if (message.isTokenRequest) {
    final babyData = await getUserData(user: User.baby);
    if (babyData.userName == message.data.userName) {
      return _saveMessageInBg(message, MessageModel.tokenRequest);
    }
  } else if (message.data.token != null) {
    return _saveMessageInBg(message, MessageModel.tokenResponse);
  }
  if (message.data.kissType != null) {
    final KissType kissType = message.data.kissType!;
    if (kissType == KissType.quickKiss) {
      saveQuickKissInBg(message..data.receiveTime = DateTime.now());
    }
  }
}

/// Processes messages acquired while app was in background.
Future processBackgroundMessages(BuildContext context) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final messages = _getBgMessages(sharedPreferences);
  if (messages[MessageModel.tokenResponse] != null ||
      messages[MessageModel.tokenRequest] != null) {
    final users = Provider.of<UsersManager>(context, listen: false);
    late String token;

    /// if message is token response, save token to shared prefs,
    /// show confirm snackbar
    if (messages[MessageModel.tokenResponse] != null) {
      token = processBgTokenResponse(
          context,
          MessageModel.fromJson(
              jsonDecode(messages[MessageModel.tokenResponse]!)));
    }

    /// if message is token request, save received token,
    /// send your token
    if (messages[MessageModel.tokenRequest] != null) {
      token = processBgTokenRequest(
          context,
          MessageModel.fromJson(
              jsonDecode(messages[MessageModel.tokenRequest]!)),
          users);
    }
    saveReceivedToken(context, token, users, sharedPreferences);
  }

  /// if there are quick kisses, filter valid ones, alert user for
  /// kiss back
  if (!Provider.of<AppStateManager>(context, listen: false).isHandlingTap) {
    if (messages[MessageModel.quickKiss] != null) {
      final quickKisses = messages[MessageModel.quickKiss];
      if (quickKisses.isNotEmpty) {
        processBgQuickKisses(context, messages[MessageModel.quickKiss]);
      }
    }
  }
}

clearTokenMessages(SharedPreferences sharedPreferences) async {
  sharedPreferences.remove(MessageModel.tokenRequest);
  sharedPreferences.remove(MessageModel.tokenResponse);
}

Map<String, dynamic> _getBgMessages(SharedPreferences sharedPreferences) {
  String? request = sharedPreferences.getString(MessageModel.tokenRequest);
  String? response = sharedPreferences.getString(MessageModel.tokenResponse);
  List<String>? quickKisses =
      sharedPreferences.getStringList(MessageModel.quickKiss);
  return {
    MessageModel.tokenRequest:
        request != null ? MessageModel.fromJson(jsonDecode(request)) : null,
    MessageModel.tokenResponse:
        response != null ? MessageModel.fromJson(jsonDecode(response)) : null,
    MessageModel.quickKiss: quickKisses
        ?.map((kiss) => MessageModel.fromJson(jsonDecode(kiss)))
        .toList()
  };
}

Future _processData(BuildContext context, {required MessageData data}) async {
  if (data.tokenRequest == true || data.token != null) {
    processTokenMessage(context: context, data: data);
  }
}

Future _saveMessageInBg(MessageModel message, String key) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString(key, message.toString());
}
