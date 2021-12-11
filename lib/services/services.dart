import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class _Services {
  static const injectionTokens = [
    'GlobalService',
    'AlertsService',
  ];
}

enum Services {
  global,
  alerts,
}

dynamic registerService(Services service) {
  _getOrRegister(service, 'register');
  return getService(service);
}

dynamic getService(Services service) {
  return _getOrRegister(service, 'get');
}

void registerInitServices() {
  registerService(Services.global);
}

BuildContext getScaffoldContext() {
  return getService(Services.global).context;
}

setScaffoldContext(BuildContext context) {
  getService(Services.global).context = context;
}

dynamic _getOrRegister(Services service, String action) {
  String injectionToken = _Services.injectionTokens[service.index];
  final _ = GetIt.instance;
  switch (injectionToken) {
    case 'AlertsService':
      return action == 'get'
          ? _.get<AlertsService>()
          : _.registerSingleton<AlertsService>(AlertsService());
    default:
      return action == 'get'
          ? _.get<GlobalService>()
          : _.registerSingleton<GlobalService>(GlobalService());
  }
}

class GlobalService {
  late BuildContext context;
}

class AlertsService {
  late GlobalKey<ScaffoldMessengerState> scaffoldKey;
  bool isHandlingTap = false;
  bool snackBarExists = false;
  bool alertExists = false;
}
