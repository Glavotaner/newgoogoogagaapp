import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';

class QuickKissTile extends StatelessWidget {
  final Message quickKiss;
  const QuickKissTile(this.quickKiss, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final progress = quickKiss.data.kissType!.data!.timeLeft!.toDouble() /
        quickKiss.data.kissType!.data!.quickKissDuration!;
    final minutesAgo = DateTime.now()
        .difference(quickKiss.data.receiveTime!)
        .inMinutes
        .toString();
    String caption = 'minute';
    if (minutesAgo != '1') {
      caption += 's';
    }
    return Card(
        elevation: 5.0,
        child: InkWell(
          child: ListTile(
            contentPadding: EdgeInsets.all(5.0),
            title: Text('$minutesAgo $caption ago'),
            subtitle: LinearProgressIndicator(value: progress),
          ),
        ));
  }
}
