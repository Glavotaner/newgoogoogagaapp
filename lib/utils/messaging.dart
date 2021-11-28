import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/message/message.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/fcm.dart';
import 'package:googoogagaapp/utils/quick_kiss.dart';
import 'package:googoogagaapp/utils/tokens.dart';
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

/// Processes messages acquired while app was in background.
Future processBackgroundMessages(
    BuildContext context, SharedPreferences sharedPreferences) async {
  final messages = _getBgMessages(sharedPreferences);
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
    saveReceivedToken(context, token, users, sharedPreferences);
  }

  // if there are quick kisses, filter valid ones, alert user for
  // kiss back
  if (!Provider.of<AppStateManager>(context, listen: false).isHandlingTap) {
    if (messages[Message.quickKiss] != null) {
      final quickKisses = messages[Message.quickKiss];
      if (quickKisses.isNotEmpty) {
        processBgQuickKisses(context, messages[Message.quickKiss]);
      }
    }
  }
}

clearTokenMessages(SharedPreferences sharedPreferences) async {
  sharedPreferences.remove(Message.tokenRequest);
  sharedPreferences.remove(Message.tokenResponse);
}

Map<String, dynamic> _getBgMessages(SharedPreferences sharedPreferences) {
  String? request = sharedPreferences.getString(Message.tokenRequest);
  String? response = sharedPreferences.getString(Message.tokenResponse);
  List<String>? quickKisses =
      sharedPreferences.getStringList(Message.quickKiss);
  return {
    Message.tokenRequest: request != null ? Message.fromString(request) : null,
    Message.tokenResponse:
        response != null ? Message.fromString(response) : null,
    Message.quickKiss:
        quickKisses?.map((kiss) => Message.fromString(kiss)).toList()
  };
}
