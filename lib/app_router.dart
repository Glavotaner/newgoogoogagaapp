import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:googoogagaapp/screens/scaffold.dart';
import 'package:googoogagaapp/screens/splash.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/screens/set_up.dart';
import 'package:googoogagaapp/providers/users_manager.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  final UsersManager usersManager;
  final ArchiveManager archiveManager;
  AppRouter(
      {required this.appStateManager,
      required this.usersManager,
      required this.archiveManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    usersManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    usersManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appStateManager.isLoading) SplashScreen.page(),
        if (appStateManager.isLoggedIn) ScaffoldScreen.page(),
        if (!appStateManager.isUserNamesSetUp && !appStateManager.isLoading)
          SetUpScreen.page(),
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
    if (appStateManager.isLoggedIn && !appStateManager.isUserNamesSetUp) {
      appStateManager.enterUsersSetUp(false);
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<void> setNewRoutePath(configuration) async => Future.value();
}
