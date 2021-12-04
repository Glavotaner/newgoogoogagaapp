import 'dart:async';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:googoogagaapp/screens/scaffold.dart';
import 'package:googoogagaapp/screens/splash.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/screens/set_up.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:googoogagaapp/utils/alerts.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  final UsersManager usersManager;
  final ArchiveManager archiveManager;
  bool _backPressed = false;
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
    archiveManager.removeListener(notifyListeners);
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
          appStateManager.leaveUserNamesSetup();
        }
        return true;
      },
    );
  }

  @override
  Future<bool> popRoute() {
    final context = navigatorKey.currentContext;
    if (appStateManager.isLoggedIn) {
      if (!appStateManager.isUserNamesSetUp) {
        return appStateManager.leaveUserNamesSetup();
      }
    }
    return _handleBackButton(context!);
  }

  @override
  Future<void> setNewRoutePath(configuration) async => Future.value();

  Future<bool> _handleBackButton(BuildContext context) {
    if (_backPressed == false) {
      _backPressed = true;
      Timer(Duration(seconds: 2), () => _backPressed = false);
      showErrorSnackbar(context, 'Tap back button again to leave app');
      return Future.value(true);
    }
    return Future.value(false);
  }
}
