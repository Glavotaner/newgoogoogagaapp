import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/home/request_input.dart';

class KissRequestPage extends StatelessWidget {
  final double opacity;
  const KissRequestPage(this.opacity, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image(image: AssetImage('assets/request.png')),
                ),
              ),
              KissRequest(),
            ],
          )),
    );
  }
}
