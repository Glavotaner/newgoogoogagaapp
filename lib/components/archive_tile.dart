import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';

class ArchiveTile extends StatelessWidget {
  final Message message;
  const ArchiveTile(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColumn = [
      if (message.title != null)
        Text(message.title!, style: theme.textTheme.headline5),
      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(message.body!, style: theme.textTheme.headline6),
      ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: textColumn),
      ),
    );
  }
}
