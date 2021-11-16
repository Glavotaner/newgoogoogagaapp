import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/utils/messaging.dart';

class KissTypeWidget extends StatefulWidget {
  final bool disabled;
  KissTypeWidget(this.kissType, {Key? key, this.disabled = false})
      : super(key: key);
  final KissType kissType;

  @override
  State<KissTypeWidget> createState() => _KissTypeWidgetState();
}

class _KissTypeWidgetState extends State<KissTypeWidget> {
  _sendKiss() async {
    sendKiss(context, widget.kissType);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 3,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image(image: AssetImage(widget.kissType.assetPath!)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(widget.kissType.title,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black54))),
              ],
            ),
            if (!widget.disabled)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.pink[50]!.withAlpha(175),
                  onTap: _sendKiss,
                ),
              ),
          ],
        ));
  }
}
