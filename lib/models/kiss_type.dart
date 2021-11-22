import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/kiss_selection/kiss_type.dart';
import 'package:googoogagaapp/components/kiss_selection/quick_kiss.dart';
import 'package:googoogagaapp/models/message.dart';

class KissType {
  String body;
  String title;
  String confirmMessage;
  String? assetPath;
  DateTime? timeReceived;
  KissTypeData? kissData;

  KissType(
      {required this.body,
      required this.title,
      required this.confirmMessage,
      this.assetPath,
      this.timeReceived,
      this.kissData});

  bool get isQuickKiss => this == KissType.quickKiss;

  Map<String, dynamic> toJson() => {
        'body': body,
        'title': title,
        'confirmMessage': confirmMessage,
        'assetPath': assetPath,
        'kissData': kissData?.toJson(),
        'timeReceived': timeReceived?.toIso8601String()
      };

  @override
  String toString() => jsonEncode(toJson());

  KissType.fromJson(Map<String, dynamic> json)
      : body = json['body'],
        title = json['title'],
        confirmMessage = json['confirmMessage'],
        assetPath = json['assetPath'],
        timeReceived = json['timeReceived'] != null
            ? DateTime.tryParse(json['timeReceived'])
            : null,
        kissData = KissTypeData.fromJson(json['kissData'] ?? '{}');

  static final List<KissType> kissTypes = [
    KissType(
        body: 'you are givded regular kiss!',
        title: 'Regular kiss',
        confirmMessage: 'you gave regular kiss, good job!',
        assetPath: 'assets/regularKiss.jpg'),
    KissType(
        body: 'wahwahweewah you got BIG kiss',
        title: 'Big kiss',
        confirmMessage: 'you send big kiss!',
        assetPath: 'assets/bigKiss.png'),
    KissType(
        body: 'hello boss, you got boss baby kiss',
        title: 'Boss baby kiss',
        confirmMessage: 'you gave boss babba kiss',
        assetPath: 'assets/bossBabyKiss.jpg')
  ];

  static final kissBack = KissType(
      body: 'I gib kiss baccc',
      title: 'Kiss back',
      confirmMessage: 'cool you gave an kiss bacc!');

  static final quickKiss = KissType(
      body: 'You gotted an quick kiss! think fast',
      title: 'Quick kiss',
      confirmMessage: 'you sented quick kiss');

  static final kissRequest = KissType(
      body: 'Request',
      title: 'Kiss request',
      confirmMessage: 'you asscc for kiss');

  @override
  bool operator ==(Object other) =>
      other is KissType &&
      other.runtimeType == runtimeType &&
      other.title == title;

  @override
  int get hashCode => title.hashCode;

  static List<Map> validQuickKisses(Messages kisses) {
    final validKisses = <Map>[];
    final now = DateTime.now();
    for (MessageModel kiss in kisses) {
      final timeReceived = kiss.data.receiveTime!;
      final int timePast = now.difference(timeReceived).inMinutes;
      final timeLeft =
          kiss.data.kissType!.kissData!.quickKissDuration! - timePast;
      if (timeLeft > 0) {
        validKisses.insert(0, {'timeLeft': timeLeft, 'message': kiss});
      }
    }
    return validKisses;
  }
}

class KissTypeData {
  int? quickKissDuration;
  KissTypeData({this.quickKissDuration});

  KissTypeData.fromJson(Map<String, dynamic> json)
      : quickKissDuration = json['quickKissDuration'];

  Map<String, dynamic> toJson() => {'quickKissDuration': quickKissDuration};
}

List<Widget> buildKissTypes(bool? disabled) {
  final List<Widget> widgets = [];
  final _disabled = disabled ?? false;
  for (KissType kissType in KissType.kissTypes) {
    if (kissType.assetPath?.isNotEmpty ?? false) {
      widgets.add(KissTypeWidget(kissType, disabled: _disabled));
    }
  }
  widgets.add(QuickKiss(disabled: disabled ?? false));
  return widgets;
}
