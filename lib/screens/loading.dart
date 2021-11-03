import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key, this.message}) : super(key: key);
  final String? message;

  static MaterialPage page() {
    return MaterialPage(
        child: LoadingScreen(),
        name: 'LoadingScreen',
        key: ValueKey('LoadingScreen'));
  }

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pageData = [const CircularProgressIndicator()];
    if (widget.message?.isNotEmpty ?? false) {
      pageData.add(Text(
        widget.message!,
        style: Theme.of(context).textTheme.headline2,
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
