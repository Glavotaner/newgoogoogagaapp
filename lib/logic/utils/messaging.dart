import 'package:flutter/material.dart';
import 'package:googoogagaapp/logic/providers/users_manager.dart';
import 'package:googoogagaapp/logic/services.dart';
import 'package:googoogagaapp/logic/utils/alerts.dart';
import 'package:googoogagaapp/logic/utils/fcm.dart';

import 'package:googoogagaapp/logic/utils/tokens.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message/message.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future sendKiss(BuildContext context, KissType kissType,
    {Map<String, dynamic>? data}) async {
  final babyData =
      Provider.of<UsersManager>(context, listen: false).usersData[User.baby]!;
  await sendMessage(token: babyData.token, notification: {
    'title': kissType.title,
    'body': kissType.body,
  });

  final AlertsService alertsService = getService(Services.alerts);
  if (!alertsService.snackBarExists) {
    alertsService.snackBarExists = true;
    showConfirmSnackbar(kissType.confirmMessage)
        .closed
        .then((_) => alertsService.snackBarExists = false);
  }
}

Future sendRequest(BuildContext context, String message) async {
  sendKiss(context, KissType.kissRequest..body = message);
}

/// Processes messages acquired while app was in background.
Future processBackgroundMessages(BuildContext context) async {
  final messages = await _getBgMessages();
  if (messages[Message.tokenResponse] != null ||
      messages[Message.tokenRequest] != null) {
    final users = Provider.of<UsersManager>(context, listen: false);
    late String token;

    // if message is token response, save token to shared prefs,
    // show confirm snackbar
    if (messages[Message.tokenResponse] != null) {
      token = processBgTokenResponse(
          context, Message.fromString(messages[Message.tokenResponse]!));
    }

    // if message is token request, save received token,
    // send your token
    if (messages[Message.tokenRequest] != null) {
      token = processBgTokenRequest(
          context, Message.fromString(messages[Message.tokenRequest]!), users);
    }
    saveReceivedToken(context, token, users);
  }
}

clearTokenMessages() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.remove(Message.tokenRequest);
  sharedPreferences.remove(Message.tokenResponse);
}

Future<Map<String, dynamic>> _getBgMessages() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  String? request = sharedPreferences.getString(Message.tokenRequest);
  String? response = sharedPreferences.getString(Message.tokenResponse);

  return {
    Message.tokenRequest: request != null ? Message.fromString(request) : null,
    Message.tokenResponse:
        response != null ? Message.fromString(response) : null,
  };
}
