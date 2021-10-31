import 'package:flutter/material.dart';
import 'package:googoogagaapp/screens/app_router.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
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

  @override
  void initState() {
    _appRouter = AppRouter(appStateManager: _appStateManager);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _appStateManager,
        child: MaterialApp(home: Router(routerDelegate: _appRouter)));
  }
}
