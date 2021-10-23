import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:googoogagaapp/utils/tokens.dart';
import 'package:googoogagaapp/widgets/global_alerts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      checkTokenExists('baby').then((tokenExists) => {
            if (!tokenExists) {showTokenAlert(context)}
          });
      setUpMessaging(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO implement home page
    return const Placeholder();
  }
}
