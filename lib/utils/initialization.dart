import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:googoogagaapp/utils/tokens.dart';
import 'package:googoogagaapp/widgets/global_alerts.dart';

Future setUpFCM() async {
  WidgetsFlutterBinding.ensureInitialized();
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

Future setUpMessaging(BuildContext context) async {
  FirebaseMessaging.onMessage
      .listen((message) => processMessage(context, message));
  FirebaseMessaging.onBackgroundMessage(saveMessageInBg);
  FirebaseMessaging.onMessageOpenedApp
      .listen((message) => processMessage(context, message));
}

Future checkBabyTokenExists(BuildContext context) async {
  final tokenExists = await checkTokenExists('baby');
  if (!tokenExists) {
    showTokenAlert(context);
  }
}
