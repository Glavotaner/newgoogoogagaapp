import 'package:flutter/material.dart';
import 'package:googoogagaapp/screens/home/home.dart';
import 'package:googoogagaapp/screens/loading/loading.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:googoogagaapp/widgets/scaffold.dart';

void main() => runApp(GoogooGagaApp());

class GoogooGagaApp extends StatelessWidget {
  final Future<dynamic> _initialize = setUpFCM();

  GoogooGagaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialize,
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
