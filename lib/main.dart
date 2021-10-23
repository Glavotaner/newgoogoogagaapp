import 'package:flutter/material.dart';
import 'package:googoogagaapp/screens/home/home.dart';
import 'package:googoogagaapp/screens/loading/loading.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:googoogagaapp/widgets/scaffold.dart';

void main() => runApp(GoogooGagaApp());

Future<dynamic> _initialize = setUpFCM();

class GoogooGagaApp extends StatelessWidget {
  final Future<dynamic> initialize = _initialize;

  GoogooGagaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialize,
        builder: (context, initSnapshot) {
          if (initSnapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
                home: ScaffoldPage(body: buildLoadingScreen('loading babba')));
          }
          final app = MaterialApp(
            home: const ScaffoldPage(body: HomePage()),
          );
          return app;
        });
  }
}
