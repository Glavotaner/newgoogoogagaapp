import 'package:flutter/material.dart';
import 'package:googoogagaapp/logic/utils/messaging.dart';

/// Processes background messages and refreshes archive list
/// on app resumed.
refreshOnAppResumed(BuildContext context) async {
  processBackgroundMessages(context);
}
