import 'package:flutter/material.dart';
import 'package:googoogagaapp/logic/services.dart';
import 'package:googoogagaapp/logic/utils/user_data.dart';
import 'package:googoogagaapp/models/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();

  static MaterialPage page() => MaterialPage(
      child: SplashScreen(), name: Routes.splash, key: ValueKey(Routes.splash));
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage('assets/splash.png')),
            Text(
              'Hello you big baby',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      registerInitServices();
      checkUsernamesSetUp(context);
    });
  }
}
