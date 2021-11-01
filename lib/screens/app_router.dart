import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/routes.dart';
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
        if (appStateManager.isLoggedIn) HomePage.page(navigatorKey),
        if (!appStateManager.isUserNamesSetUp) LoginPage.page(),
      ],
      onPopPage: (route, result) {
        if (!(route.didPop(result))) {
          return false;
        }
        if (route.settings.name == Routes.setUp) {
          appStateManager.setUpUserNames(true);
        }

        return true;
      },
    );
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    if (appStateManager.isLoggedIn && !appStateManager.isUserNamesSetUp) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
