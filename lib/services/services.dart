import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class _Services {
  static const injectionTokens = [
    'GlobalService',
    'AlertsService',
  ];
}

enum ServicesEnum {
  global,
  alerts,
}

void registerService(ServicesEnum service) {
  _getOrRegister(service, 'register');
}

dynamic getService(ServicesEnum service) {
  return _getOrRegister(service, 'get');
}

dynamic _getOrRegister(ServicesEnum service, String action) {
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

BuildContext getScaffoldContext() {
  return getService(ServicesEnum.global).context;
}

class GlobalService {
  late BuildContext context;
}

class AlertsService {
  bool isHandlingTap = false;
  bool snackBarExists = false;
  bool alertExists = false;
}
