import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/utils/user_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
        child: SplashScreen(),
        name: Routes.splash,
        key: ValueKey(Routes.splash));
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      checkUsernamesSetUp(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image(image: AssetImage('assets/splash.png')),
        Text(
          'Hello you big baby',
          style: Theme.of(context).textTheme.headline5,
        )
      ],
    );
  }
}
