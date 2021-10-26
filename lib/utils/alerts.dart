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
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)));
}

showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red));
}

showUsersAlert(BuildContext context, Map<String, User?> userData) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('User data missing!'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Please put in some usernames please thank you'),
              ),
              TextField(
                  decoration: InputDecoration(
                      hintText: userData['me'] == null
                          ? 'Please put in your username here'
                          : null)),
              TextField(
                  decoration: InputDecoration(
                      hintText: userData['baby'] == null
                          ? 'Please put in baby username here'
                          : null)),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  print('done');
                },
                child: Text('Save usernames'))
          ],
        );
      });
}
