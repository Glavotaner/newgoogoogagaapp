import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/screens/home.dart';
import 'package:googoogagaapp/screens/splash.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
import 'package:googoogagaapp/screens/login.dart';
import 'package:googoogagaapp/utils/users_state_manager.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  final UsersStateManager usersStateManager;
  AppRouter({required this.appStateManager, required this.usersStateManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    usersStateManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    usersStateManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appStateManager.isLoading) SplashScreen.page(),
        if (appStateManager.isLoggedIn) HomePage.page(navigatorKey),
        if (!appStateManager.isUserNamesSetUp && !appStateManager.isLoading)
          LoginPage.page(),
      ],
      onPopPage: (route, result) {
        if (!(route.didPop(result))) {
          return false;
        }
        if (route.settings.name == Routes.setUp) {
          appStateManager.enterUsersSetUp(false);
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
