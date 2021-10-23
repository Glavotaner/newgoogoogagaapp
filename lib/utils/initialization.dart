import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:googoogagaapp/utils/tokens.dart';

Future setUpFCM() async {
  await Firebase.initializeApp();
  if (!(await checkTokenExists('me'))) {
    final messaging = FirebaseMessaging.instance;
    final String? newToken = await messaging.getToken();
    if (newToken != null && newToken.isNotEmpty) {
      setToken('me', newToken);
    }
  }
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

setUpMessaging(BuildContext context) async {
  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification != null) {
      showMessageAlert(context,
          body: notification.body!, title: notification.title);
    }
  });
  FirebaseMessaging.onBackgroundMessage(saveMessageInBg);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final notification = message.notification;
    if (notification != null) {
      showMessageAlert(context,
          body: notification.body!, title: notification.title);
    }
  });
}
