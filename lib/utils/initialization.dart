import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googoogagaapp/models/message/message.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/fcm.dart';
import 'package:googoogagaapp/utils/fcm_handlers.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:googoogagaapp/utils/tokens.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:provider/provider.dart';

/// Initializes Firebase, sets up notifications channel for foreground notifications,
/// sets up message handlers, sets up user token, if missing, requests baby token, if missing.
Future setUpMessaging(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  await Future.wait([_setUpNotificationChannel(), _setUpMessaging()]);
  _refreshTokens(context);
}

/// Sends a token request to the tokens topic.
Future refreshBabyToken(BuildContext context) async {
  final myUser =
      Provider.of<UsersManager>(context, listen: false).usersData[User.me]!;
  await FirebaseMessaging.instance.subscribeToTopic('tokens');
  sendDataMessage(
      topic: 'tokens',
      data: MessageData(
          token: myUser.token, tokenRequest: true, userName: myUser.userName));
  if (!(await checkIsWaitingForToken())) {
    showConfirmSnackbar('Refreshing!');
  }
  setSearchingForToken();
}

/// Gets user token from FCM, if missing, calls [refreshBabyToken] to request baby token, if missing.
/// Processes messages acquired while app was in background. They can contain token request and responses.
Future _refreshTokens(BuildContext context) async {
  final users = Provider.of<UsersManager>(context, listen: false);
  final userData = users.usersData[User.me]!;
  if (!userData.hasToken) {
    await _setFCMToken(context: context, userData: userData);
  }
  final babyUserData = users.usersData[User.baby]!;
  if (!babyUserData.hasToken) {
    refreshBabyToken(context);
  }
  processBackgroundMessages(context);
}

/// Sets up Firebase messaging handlers.
Future _setUpMessaging() async {
  // foreground listener
  FirebaseMessaging.onMessage.listen(onMessage);
  // background listener
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  // tap listener
  FirebaseMessaging.onMessageOpenedApp.listen(onTappedNotification);
}

/// Sets up high importance notification channel to enable foreground notifications.
Future _setUpNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'));
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

/// Gets device token from FCM and sets it as the user's token.
Future _setFCMToken(
    {required BuildContext context, required User userData}) async {
  final messaging = FirebaseMessaging.instance;
  final token = await messaging.getToken();
  if (token?.isNotEmpty ?? false) {
    updateUserData(context, User.me, userData..token = token);
  } else {
    showErrorSnackbar('Token error!');
    throw ErrorDescription('Token error!');
  }
}
