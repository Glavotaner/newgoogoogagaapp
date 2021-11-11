import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:provider/provider.dart';

Future setUpMessaging(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  await Future.wait([_setUpNotificationChannel(), _setUpMessaging(context)]);
  _refreshTokens(context);
}

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
  processBgMessages(context);
}

Future refreshBabyToken([BuildContext? context, GlobalKey? navKey]) async {
  final myUser = context == null
      ? await getUserData(user: User.me)
      : Provider.of<UsersManager>(context, listen: false).usersData[User.me]!;
  await FirebaseMessaging.instance.subscribeToTopic('tokens');
  sendDataMessage(
      topic: 'tokens',
      data: MessageData(
          token: myUser.token, tokenRequest: true, userName: myUser.userName));
  showConfirmSnackbar(context!, 'Refreshing!');
}

Future _setUpMessaging(BuildContext context) async {
  FirebaseMessaging.onMessage.listen((message) {
    processMessage(context, MessageModel.fromRemote(message));
  });
  FirebaseMessaging.onBackgroundMessage(processMessageInBg);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    processMessage(context, MessageModel.fromRemote(message));
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
