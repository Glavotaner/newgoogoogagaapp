import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/home/request_input.dart';
import 'package:googoogagaapp/components/home/swipe_hint.dart';
import 'package:googoogagaapp/components/kiss_selection/kiss_selection.dart';
import 'package:googoogagaapp/components/loading.dart';
import 'package:googoogagaapp/utils/initialization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future _setUpMessaging;
  int selectedPage = 0;
  double opacity = 1.0;

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
            return Stack(children: [
              SwipeHint(opacity: opacity, page: selectedPage),
              PageView(
                scrollDirection: Axis.vertical,
                children: [_homePage, KissSelectionScreen()],
              ),
            ]);
          }
          return LoadingScreen(
            message: 'Setting up messaging...',
          );
        });
  }

  final Widget _homePage = Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(image: AssetImage('assets/request.png')),
            ),
          ),
          KissRequest(),
        ],
      ));
}
