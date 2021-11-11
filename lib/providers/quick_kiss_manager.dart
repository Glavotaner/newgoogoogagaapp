import 'dart:async';

import 'package:flutter/material.dart';

class QuickKissManager extends ChangeNotifier {
  DateTime? _receiveTime;
  Duration _duration = Duration(seconds: 0);
  int _minutesLeft = 0;
  String? _messageId;

  Duration get duration => _duration;
  DateTime? get receiveTime => _receiveTime;
  int get minutesLeft => _minutesLeft;
  String? get messageId => _messageId;

  getTimer(DateTime timeReceived, int kissDuration) {
    _receiveTime = timeReceived;
    final difference = DateTime.now().difference(timeReceived);
    if (!difference.isNegative) {
      if (difference.inMinutes < kissDuration) {
        _duration = Duration(minutes: kissDuration);
        _minutesLeft = kissDuration - _duration.inMinutes;
        return startTimer();
      }
    }
    clearTimer();
  }

  startTimer() {
    notifyListeners();
    Timer.periodic(Duration(seconds: 5), _updateTimer);
  }

  clearTimer() async {
    _receiveTime = null;
    _duration = Duration(seconds: 0);
    _minutesLeft = 0;
    notifyListeners();
  }

  _updateTimer(Timer timer) {
    if (_minutesLeft - 1 >= 0) {
      _minutesLeft--;
      notifyListeners();
    } else {
      timer.cancel();
      clearTimer();
    }
  }
}
