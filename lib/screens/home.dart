import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/request_input.dart';
import 'package:googoogagaapp/components/kiss_selection.dart';
import 'package:googoogagaapp/components/loading.dart';
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
