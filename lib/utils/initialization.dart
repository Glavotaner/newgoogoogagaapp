import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:googoogagaapp/utils/user_data.dart';

Future setUpMessaging(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  await Future.wait([_setUpNotificationChannel(), _setUpMessaging(context)]);
  _refreshTokens(context);
}

Future _refreshTokens(BuildContext context) async {
  final userData = await getUserData(user: User.me);
  if (!userData.hasToken) {
    await _setFCMToken(context: context, userData: userData);
  }
  final babyUserData = await getUserData(user: User.baby);
  if (!babyUserData.hasToken) {
    refreshBabyToken(context);
  }
  processBgMessages(context);
}

Future refreshBabyToken([BuildContext? context, GlobalKey? navKey]) async {
  final myUser = await getUserData(context: context, user: User.me);
  await FirebaseMessaging.instance.subscribeToTopic('tokens');
  sendDataMessage(topic: 'tokens', data: {
    'token': myUser.token,
    'tokenRequest': true,
    'username': myUser.userName
  });
  showConfirmSnackbar(context!, 'Refreshing!');
}

Future _setUpMessaging(BuildContext context) async {
  FirebaseMessaging.onMessage.listen((message) {
    processMessage(context, message);
  });
  FirebaseMessaging.onBackgroundMessage(processMessageInBg);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    processMessage(context, message);
  });
}

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

Future _setFCMToken(
    {required BuildContext context, required User userData}) async {
  final messaging = FirebaseMessaging.instance;
  final token = await messaging.getToken();
  if (token?.isNotEmpty ?? false) {
    setUserData(context, User.me, userData..token = token);
  } else {
    showErrorSnackbar(context, 'Token error!');
    throw ErrorDescription('Token error!');
  }
}
