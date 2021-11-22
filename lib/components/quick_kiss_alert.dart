import 'dart:async';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/messaging.dart';

class QuickKissAlert extends StatefulWidget {
  final KissType quickKiss;
  final BuildContext parentContext;
  const QuickKissAlert(this.quickKiss, {Key? key, required this.parentContext})
      : super(key: key);
  @override
  _QuickKissAlertState createState() => _QuickKissAlertState();
}

class _QuickKissAlertState extends State<QuickKissAlert> {
  late int minutesLeft;
  late Timer durationTimer;

  _setRemainingTime(Timer? timer) {
    if (!mounted) return durationTimer.cancel();
    if (minutesLeft - 1 > 0) {
      return setState(() {
        minutesLeft--;
      });
    }
    timer?.cancel();
    showErrorSnackbar(context,
        "uhoh looks like you didn't send kiss back in time, this is very sad thing");
    Navigator.of(context, rootNavigator: true).pop();
  }

  _sendKissBack(BuildContext context) {
    sendKiss(widget.parentContext, KissType.kissBack);
    Navigator.of(context, rootNavigator: true).pop(true);
  }

  @override
  void initState() {
    super.initState();
    minutesLeft = widget.quickKiss.kissData!.quickKissDuration!;
    durationTimer = Timer.periodic(Duration(minutes: 1), _setRemainingTime);
  }

  @override
  void dispose() {
    durationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      child: SizedBox(
        height: 400,
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.quickKiss.title,
              style: textTheme.headline5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Text(minutesLeft.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Minutes left', style: textTheme.headline6),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Text(
                widget.quickKiss.body,
                style: textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton.icon(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(100, 50))),
                onPressed: () => _sendKissBack(context),
                icon: Icon(Icons.favorite),
                label: Text(
                  'send kiss baccc',
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }
}
