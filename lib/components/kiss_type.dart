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
      print(_disable);
    });
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child:
                          Image(image: AssetImage(widget.kissType.assetPath!)),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(widget.kissType.title,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black87))),
                ],
              ),
              if (!_disable)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.pink[50]!.withAlpha(175),
                    onTap: () => sendKiss(context, widget.kissType),
                  ),
                ),
            ],
          )),
    );
  }
}
