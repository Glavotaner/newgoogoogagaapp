import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String? message;
  const LoadingScreen(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageData = [const CircularProgressIndicator()];
    if (message?.isNotEmpty ?? false) {
      pageData.add(Text(
        message!,
        style: Theme.of(context).textTheme.headline6,
      ));
    }
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: pageData,
      )),
    );
  }
}
