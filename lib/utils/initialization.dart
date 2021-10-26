import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:googoogagaapp/utils/user_data.dart';

Future setUpMessaging(BuildContext context) async {
  final userData = await getUserData(user: 'me');
  await Firebase.initializeApp();
  if (!userData.hasToken) {
    await _setFCMToken(context: context, userData: userData);
  }
  final babyUserData = await getUserData(user: 'baby');
  if (!babyUserData.hasToken) {
    await _refreshBabyToken(context);
  }
  await Future.wait([_setUpNotificationChannel(), _setUpMessaging(context)]);
  processBgMessages(context);
}

Future _setUpMessaging(BuildContext context) async {
  FirebaseMessaging.onMessage
      .listen((message) => processMessage(context, message));
  FirebaseMessaging.onBackgroundMessage(processMessageInBg);
  FirebaseMessaging.onMessageOpenedApp
      .listen((message) => processMessage(context, message));
}

Future _setUpNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // TODO add icon
  const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'));
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
    setUserData('me', userData..token = token);
  } else {
    showErrorSnackbar(context, 'Token error!');
    throw ErrorDescription('Token error!');
  }
}

Future _refreshBabyToken(BuildContext context) async {
  final myUser = await getUserData(context: context, user: 'me');
  sendDataMessage('topics/tokens',
      {'customData': true, 'tokenRequest': true, 'username': myUser.userName});
}
