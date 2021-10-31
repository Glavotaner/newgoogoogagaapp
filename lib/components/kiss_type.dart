import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/utils/messaging.dart';

class KissTypeWidget extends StatelessWidget {
  KissTypeWidget(this.kissType, {Key? key}) : super(key: key);
  final KissType kissType;

  @override
  Widget build(BuildContext context) {
    // TODO implement kiss type widget
    return Card(
        elevation: 5,
        child: Stack(
          children: [
            InkWell(
              splashColor: Colors.pink[50],
              onTap: () => sendKiss(context, kissType),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(image: AssetImage(kissType.assetPath!)),
                Text(kissType.title)
              ],
            )
          ],
        ));
  }
}
