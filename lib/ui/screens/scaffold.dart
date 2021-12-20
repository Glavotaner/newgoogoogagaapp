import 'package:flutter/material.dart';
import 'package:googoogagaapp/logic/providers/app_state_manager.dart';
import 'package:googoogagaapp/logic/providers/users_manager.dart';
import 'package:googoogagaapp/logic/utils/alerts.dart';
import 'package:googoogagaapp/logic/utils/initialization.dart';
import 'package:googoogagaapp/logic/utils/messaging.dart';
import 'package:googoogagaapp/logic/utils/state.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:googoogagaapp/ui/components/loading.dart';
import 'package:googoogagaapp/ui/screens/home.dart';
import 'package:provider/provider.dart';

class ScaffoldScreen extends StatefulWidget {
  ScaffoldScreen({Key? key}) : super(key: key);

  static MaterialPage page() => MaterialPage(
        name: Routes.home,
        key: ValueKey(Routes.home),
        child: ScaffoldScreen(),
      );

  @override
  _ScaffoldScreenState createState() => _ScaffoldScreenState();
}

class _ScaffoldScreenState extends State<ScaffoldScreen>
    with WidgetsBindingObserver {
  bool _showingSnackbar = false;
  late Future<void> _setUpMessaging;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _setUpMessaging = setUpMessaging(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                color: Theme.of(context).cardColor,
                onPressed: () =>
                    Provider.of<AppStateManager>(context, listen: false)
                        .enterUsersSetUp(),
                icon: Icon(Icons.people)),
            Selector<UsersManager, NullableUsersData>(
              selector: (_, users) => users.usersData,
              builder: (context, usersData, child) {
                // TODO animate scanning for token
                return IconButton(
                    color: Colors.redAccent,
                    onPressed: usersData[User.me]?.token == null
                        ? null
                        : () => refreshBabyToken(context),
                    icon: Icon(usersData[User.baby]?.token == null
                        ? Icons.favorite_border
                        : Icons.favorite));
              },
            )
          ],
          title: const Text('Googoo Gaga App'),
          bottomOpacity: 0,
          centerTitle: true),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _setUpMessaging,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return HomeScreen();
            }
            return LoadingScreen(message: 'Setting up messaging...');
          }),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      refreshOnAppResumed(context);
    }
  }

  sendKissBack(BuildContext context) {
    sendKiss(context, KissType.kissBack);
    if (!_showingSnackbar) {
      _showingSnackbar = true;
      showConfirmSnackbar(KissType.kissBack.confirmMessage)
          .closed
          .then((_) => _showingSnackbar = false);
    }
  }
}
