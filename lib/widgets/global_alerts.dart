import 'package:flutter/material.dart';

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
