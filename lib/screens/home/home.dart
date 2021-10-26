import 'package:flutter/material.dart';
import 'package:googoogagaapp/screens/loading/loading.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:googoogagaapp/widgets/scaffold.dart';

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
    // TODO implement home page
    return FutureBuilder(
        future: _setUpMessaging,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              home: ScaffoldPage(
                  body: Column(
                children: [Text('test')],
              )),
            );
          }
          return LoadingScreen(message: 'Loading messaging...');
        });
  }
}
