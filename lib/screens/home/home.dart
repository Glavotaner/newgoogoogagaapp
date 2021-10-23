import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/initialization.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future _setUpMessaging;

  @override
  void initState() {
    super.initState();
    _setUpMessaging =
        Future.wait([setUpMessaging(context), checkBabyTokenExists(context)]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO implement home page
    return FutureBuilder(
        future: _setUpMessaging,
        builder: (BuildContext context, _) {
          return const Placeholder();
        });
  }
}
