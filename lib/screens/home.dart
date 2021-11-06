import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/request_input.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/screens/loading.dart';
import 'package:googoogagaapp/screens/unread.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:googoogagaapp/components/scaffold.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  const HomePage(this.navKey, {Key? key}) : super(key: key);

  static MaterialPage page(GlobalKey<NavigatorState> navKey) {
    return MaterialPage(
      name: Routes.home,
      key: ValueKey(Routes.home),
      child: HomePage(navKey),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future _setUpMessaging;

  @override
  void initState() {
    super.initState();
    _setUpMessaging = setUpMessaging(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _setUpMessaging,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final _pageView = PageView(
              scrollDirection: Axis.vertical,
              children: [
                _homePage,
                PageView(
                  scrollDirection: Axis.horizontal,
                  children: buildKissTypes(),
                )
              ],
            );
            return ScaffoldPage(pages: [_pageView, KissArchive()]);
          }
          return LoadingScreen(
            message: 'Setting up messaging...',
          );
        });
  }

  final Widget _homePage = Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Placeholder(),
        ),
      ),
      KissRequest()
    ],
  );
}
