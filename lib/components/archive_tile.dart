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
      Text(message.body!, style: theme.textTheme.headline6),
    ];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: textColumn),
      ),
    );
  }
}
