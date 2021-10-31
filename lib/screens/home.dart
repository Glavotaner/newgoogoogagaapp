import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/request_input.dart';
import 'package:googoogagaapp/screens/loading.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:googoogagaapp/components/scaffold.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  const HomePage(this.navKey, {Key? key}) : super(key: key);

  static MaterialPage page(GlobalKey<NavigatorState> navKey) {
    return MaterialPage(
      name: 'Home',
      key: ValueKey('Home'),
      child: HomePage(navKey),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future _setUpMessaging;
  late bool _needsInit;

  @override
  void initState() {
    super.initState();
    _needsInit =
        !Provider.of<AppStateManager>(context, listen: false).isinitialized;
    if (_needsInit) {
      _setUpMessaging = setUpMessaging(widget.navKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        if (_needsInit) {
          return FutureBuilder(
              future: _setUpMessaging,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ScaffoldPage(body: homePage());
                }
                return LoadingScreen();
              });
        }
        return ScaffoldPage(body: homePage());
      },
    );
  }

  Widget homePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Expanded(child: Placeholder()), KissRequest()],
    );
  }
}
