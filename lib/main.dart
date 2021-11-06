import 'package:flutter/material.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:googoogagaapp/screens/app_router.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GoogooGagaApp());
}

class GoogooGagaApp extends StatefulWidget {
  GoogooGagaApp({Key? key}) : super(key: key);

  @override
  State<GoogooGagaApp> createState() => _GoogooGagaAppState();
}

class _GoogooGagaAppState extends State<GoogooGagaApp> {
  late AppRouter _appRouter;
  final _appStateManager = AppStateManager();
  final _usersManager = UsersManager();
  final _archiveManager = ArchiveManager();

  @override
  void initState() {
    _appRouter = AppRouter(
        appStateManager: _appStateManager,
        usersManager: _usersManager,
        archiveManager: _archiveManager);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => _appStateManager),
          ChangeNotifierProvider(create: (context) => _usersManager),
          ChangeNotifierProvider(create: (context) => _archiveManager),
        ],
        child: MaterialApp(
            home: Router(
                routerDelegate: _appRouter,
                backButtonDispatcher: RootBackButtonDispatcher())));
  }
}
