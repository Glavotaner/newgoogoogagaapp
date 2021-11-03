import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:provider/provider.dart';

class KissTypeWidget extends StatefulWidget {
  KissTypeWidget(this.kissType, {Key? key}) : super(key: key);
  final KissType kissType;

  @override
  State<KissTypeWidget> createState() => _KissTypeWidgetState();
}

class _KissTypeWidgetState extends State<KissTypeWidget> {
  @override
  Widget build(BuildContext context) {
    bool _disable = false;
    context.watch<UsersManager>().usersData.forEach((key, value) {
      if (value?.token == null) {
        _disable = true;
      }
    });
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
          elevation: 5,
          child: Stack(
            children: [
              if (!_disable)
                InkWell(
                  splashColor: Colors.pink[50],
                  onTap: () => sendKiss(context, widget.kissType),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Placeholder()),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Chip(
                      elevation: 5,
                      backgroundColor: _disable ? Colors.grey : Colors.red[100],
                      label: Text(widget.kissType.title,
                          style: TextStyle(fontSize: 24)),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
