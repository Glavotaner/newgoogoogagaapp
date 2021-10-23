import 'package:flutter/material.dart';

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
