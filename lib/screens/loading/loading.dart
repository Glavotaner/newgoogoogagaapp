import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key, this.message}) : super(key: key);
  final String? message;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageData = [const CircularProgressIndicator()];
    if (message?.isNotEmpty ?? false) {
      pageData.add(Text(message!));
    }
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: pageData,
        )),
      ),
    );
  }
}
