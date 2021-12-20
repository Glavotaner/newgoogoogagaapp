import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googoogagaapp/app_router.dart';
import 'package:googoogagaapp/logic/providers/app_state_manager.dart';
import 'package:googoogagaapp/logic/providers/users_manager.dart';
import 'package:googoogagaapp/logic/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  runApp(GoogooGagaApp());
}

class GoogooGagaApp extends StatefulWidget {
  GoogooGagaApp({Key? key}) : super(key: key);

  @override
  State<GoogooGagaApp> createState() => _GoogooGagaAppState();
}

class _GoogooGagaAppState extends State<GoogooGagaApp> {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late AppRouter _appRouter;
  final _appStateManager = AppStateManager();
  final _usersManager = UsersManager();

  @override
  void initState() {
    _appRouter = AppRouter(
        appStateManager: _appStateManager, usersManager: _usersManager);
    final AlertsService alertsService = registerService(Services.alerts);
    alertsService.scaffoldKey = scaffoldKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => _appStateManager),
          ChangeNotifierProvider(create: (context) => _usersManager),
        ],
        child: MaterialApp(
            home: Scaffold(
          key: scaffoldKey,
          body: Router(
              routerDelegate: _appRouter,
              backButtonDispatcher: RootBackButtonDispatcher()),
        )));
  }
}
