import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';

Future showAlert(
    {required BuildContext context,
    required String body,
    String? title,
    List<TextButton>? actions}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null && title.isNotEmpty ? Text(title) : null,
          content: Text(body),
          actions: actions != null && actions.isNotEmpty ? actions : null,
        );
      });
}

showConfirmSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
