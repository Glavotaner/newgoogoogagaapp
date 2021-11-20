import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/archive.dart';
import 'package:googoogagaapp/utils/messaging.dart';

/// Processes background messages and refreshes archive list
/// on app resumed.
refreshOnAppResumed(BuildContext context) {
  processBackgroundMessages(context);
  getArchive(context);
}
