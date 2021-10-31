import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/user_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
        child: SplashScreen(),
        name: 'SplashScreen',
        key: ValueKey('SplashScreen'));
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUsernamesSetUp(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [CircularProgressIndicator(), Text('Setting fings up...')],
      )),
    );
  }
}
