import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/home/request_input.dart';
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
            return PageView(
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _homePage,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: KissSelectionScreen(),
                )
              ],
            );
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
          child: Image(image: AssetImage('assets/request.png')),
        ),
      ),
      KissRequest()
    ],
  );
}
