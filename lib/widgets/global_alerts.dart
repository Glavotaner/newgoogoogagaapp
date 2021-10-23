import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/alerts.dart';

Future showTokenAlert(BuildContext context) {
  return showAlert(
      context: context,
      body: 'You don"t hab da babies token, go asssscc for it!',
      title: 'Missing token!',
      actions: [
        TextButton(
          child: const Text('Ok gosh I"ll go ask'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ]);
}

class LoadingDialog {
  late BuildContext context;
  String? message;
  LoadingDialog(this.context, {this.message});

  Future show() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext diagContext) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                Text(message ?? 'Loading'),
              ],
            ),
          );
        });
  }

  dismiss() {
    Navigator.of(context).pop();
  }
}
