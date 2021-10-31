import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:provider/provider.dart';

Future setUpMessaging(GlobalKey<NavigatorState> navKey) async {
  final userData = await getUserData(user: 'me');
  await Firebase.initializeApp();
  if (!userData.hasToken) {
    _setFCMToken(context: navKey, userData: userData);
  }
  await Future.wait([_setUpNotificationChannel(), _setUpMessaging(navKey)]);
  final babyUserData = await getUserData(user: 'baby');
  final context = navKey.currentContext!;
  if (!babyUserData.hasToken) {
    await refreshBabyToken(context);
  }
  processBgMessages(navKey);
  Provider.of<AppStateManager>(context, listen: false).initializeMessaging();
}

Future refreshBabyToken(BuildContext context) async {
  final myUser = await getUserData(context: context, user: 'me');
  await FirebaseMessaging.instance.subscribeToTopic('tokens');
  sendDataMessage(topic: 'tokens', data: {
    'token': myUser.token,
    'tokenRequest': true,
    'username': myUser.userName
  });
  showConfirmSnackbar(context, 'Refreshing!');
}

Future _setUpMessaging(GlobalKey key) async {
  FirebaseMessaging.onMessage.listen((message) {
    final context = key.currentContext;
    processMessage(context!, message);
  });
  FirebaseMessaging.onBackgroundMessage(processMessageInBg);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final context = key.currentContext;
    processMessage(context!, message);
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
    {required GlobalKey context, required User userData}) async {
  final messaging = FirebaseMessaging.instance;
  final token = await messaging.getToken();
  if (token?.isNotEmpty ?? false) {
    setUserData('me', userData..token = token);
  } else {
    final ctx = context.currentContext;
    showErrorSnackbar(ctx!, 'Token error!');
    throw ErrorDescription('Token error!');
  }
}
