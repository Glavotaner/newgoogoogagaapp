import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key, this.message}) : super(key: key);
  final String? message;

  static MaterialPage page() {
    return MaterialPage(
        child: LoadingScreen(),
        name: 'LoadingScreen',
        key: ValueKey('LoadingScreen'));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageData = [const CircularProgressIndicator()];
    if (message?.isNotEmpty ?? false) {
      pageData.add(Text(
        message!,
        style: Theme.of(context).textTheme.headline4,
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
