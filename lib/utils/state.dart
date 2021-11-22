import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/archive.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Processes background messages and refreshes archive list
/// on app resumed.
refreshOnAppResumed(BuildContext context) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.reload();
  processBackgroundMessages(context, sharedPreferences);
  getArchive(context, sharedPreferences);
}
