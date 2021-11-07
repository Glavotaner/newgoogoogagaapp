import 'dart:async';

import 'package:flutter/material.dart';

class QuickKissManager extends ChangeNotifier {
  DateTime? _receiveTime;
  Duration _duration = Duration(seconds: 0);
  int _minutesLeft = 0;

  Duration get duration => _duration;
  DateTime? get receiveTime => _receiveTime;
  int get minutesLeft => _minutesLeft;

  getTimer(DateTime timeReceived, int kissDuration) {
    _receiveTime = timeReceived;
    final difference = DateTime.now().difference(timeReceived);
    if (!difference.isNegative) {
      _duration = difference;
      if (_duration.inMinutes > kissDuration) {
        _minutesLeft = _duration.inMinutes - kissDuration;
        return startTimer();
      }
    }
    clearTimer();
  }

  startTimer() {
    Timer.periodic(Duration(minutes: 1), _updateTimer);
  }

  clearTimer() {
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
