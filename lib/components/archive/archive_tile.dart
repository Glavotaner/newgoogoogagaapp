import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message/message.dart';

class ArchiveTile extends StatelessWidget {
  final Message message;
  const ArchiveTile(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
        child: ListTile(
      contentPadding: EdgeInsets.all(5.0),
      title: message.title != null
          ? Text(message.title!, style: textTheme.headline5)
          : null,
      subtitle: Text(message.body!, style: textTheme.headline6),
    ));
  }
}
