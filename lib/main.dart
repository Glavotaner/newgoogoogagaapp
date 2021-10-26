import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/screens/home/home.dart';
import 'package:googoogagaapp/screens/loading/loading.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:googoogagaapp/widgets/scaffold.dart';
import 'package:googoogagaapp/widgets/users_setup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GoogooGagaApp());
}

class GoogooGagaApp extends StatelessWidget {
  final Future<Map<String, User?>> _checkUserNames = checkUsernamesSetUp();

  GoogooGagaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkUserNames,
        builder: (context, AsyncSnapshot<Map<String, User?>> usersData) {
          if (usersData.connectionState == ConnectionState.done) {
            if (usersData.hasData) {
              if (usersData.data?.containsValue(null) ?? false) {
                return MaterialApp(
                    home: Scaffold(
                  body: UsersSetUpWidget(usersData.data!),
                ));
              }
              return MaterialApp(home: const ScaffoldPage(body: HomePage()));
            }
          }
          return LoadingScreen(message: 'Loading...');
        });
  }
}
