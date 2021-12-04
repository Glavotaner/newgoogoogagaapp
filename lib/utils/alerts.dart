import 'dart:async';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/services/services.dart';

Future showAlert(
    {required BuildContext context,
    required String body,
    String? title,
    int? duration,
    List<TextButton>? actions}) async {
  final AlertsService alertsService = getService(ServicesEnum.alerts);
  if (!alertsService.alertExists) {
    alertsService.alertExists = true;
    Timer? timer;
    await showDialog(
        context: context,
        builder: (BuildContext dialogCtx) {
          if (duration != null) {
            timer = Timer(Duration(seconds: duration), () {
              Navigator.of(dialogCtx, rootNavigator: true).pop();
            });
          }
          return AlertDialog(
            title: title != null && title.isNotEmpty ? Text(title) : null,
            content: Text(body),
            actions: actions != null && actions.isNotEmpty ? actions : null,
          );
        });
    timer?.cancel();
    timer = null;
    alertsService.alertExists = false;
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showConfirmSnackbar(
    BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2),
    backgroundColor: Theme.of(context).colorScheme.primary,
  ));
}

showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red));
}
