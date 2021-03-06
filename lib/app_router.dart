import 'dart:async';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/logic/providers/app_state_manager.dart';
import 'package:googoogagaapp/logic/providers/users_manager.dart';
import 'package:googoogagaapp/logic/utils/alerts.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/ui/screens/scaffold.dart';
import 'package:googoogagaapp/ui/screens/set_up.dart';
import 'package:googoogagaapp/ui/screens/splash.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  final UsersManager usersManager;
  bool _backPressed = false;

  AppRouter({required this.appStateManager, required this.usersManager})
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
        if (appStateManager.isInitialized) ScaffoldScreen.page(),
        if (!appStateManager.isUsersSetUp && !appStateManager.isLoading)
          SetUpScreen.page(),
      ],
      onPopPage: (route, result) {
        if (!(route.didPop(result))) {
          return false;
        }
        if (route.settings.name == Routes.setUp) {
          appStateManager.leaveUsersSetUp();
        }
        return true;
      },
    );
  }

  @override
  Future<bool> popRoute() {
    final context = navigatorKey.currentContext;
    if (appStateManager.isInitialized) {
      if (!appStateManager.isUsersSetUp) {
        return appStateManager.leaveUsersSetUp();
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
      showErrorSnackbar('Tap back button again to leave app');
      return Future.value(true);
    }
    return Future.value(false);
  }
}
