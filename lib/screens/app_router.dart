import 'package:flutter/material.dart';
import 'package:googoogagaapp/screens/home.dart';
import 'package:googoogagaapp/screens/splash.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
import 'package:googoogagaapp/screens/login.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  AppRouter({required this.appStateManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appStateManager.isLoading) SplashScreen.page(),
        if (!appStateManager.isUserNamesSetUp && !appStateManager.isLoading)
          LoginPage.page(),
        if (appStateManager.isUserNamesSetUp && !appStateManager.isLoading)
          HomePage.page(navigatorKey),
      ],
      onPopPage: (route, result) {
        if (!(route.didPop(result))) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
