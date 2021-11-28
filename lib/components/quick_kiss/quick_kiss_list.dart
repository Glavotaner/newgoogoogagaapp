import 'dart:async';

import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/loading.dart';
import 'package:googoogagaapp/components/quick_kiss/quick_kiss_tile.dart';
import 'package:googoogagaapp/models/message/message.dart';
import 'package:googoogagaapp/utils/quick_kiss.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickKissListSheet extends StatefulWidget {
  final Messages validKisses;
  final int initialCount;
  final Message? tappedMessage;
  const QuickKissListSheet(
      {Key? key,
      required this.validKisses,
      required this.initialCount,
      this.tappedMessage})
      : super(key: key);
  @override
  _QuickKissListSheetState createState() => _QuickKissListSheetState();
}

class _QuickKissListSheetState extends State<QuickKissListSheet> {
  final _listState = GlobalKey<AnimatedListState>();
  late Future<void> _setUpKisses;
  Messages _validKisses = [];
  late Timer _updateKissesTimer;

  @override
  void dispose() {
    _updateKissesTimer.cancel();
    _clearKisses();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setUpKisses = _getQuickKisses(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 730.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSendButton(context),
                Expanded(
                    child: FutureBuilder(
                  future: _setUpKisses,
                  builder: buildList,
                )),
              ],
            )));
  }

  Widget buildList(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return AnimatedList(
        key: _listState,
        initialItemCount: widget.initialCount,
        itemBuilder: (context, index, animation) {
          return _kissTile(context, index, animation);
        },
      );
    }
    return LoadingScreen(message: 'Getting kisses...');
  }

  Widget buildSendButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0))))),
        onPressed: () => _gibBaccAll(context),
        icon: Icon(Icons.favorite),
        label: Text(
          'send bacc all kisses',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _kissTile(BuildContext context, int index, animation) {
    return SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: QuickKissTile(
          _validKisses[index],
        ));
  }

  Future<void> _getQuickKisses(BuildContext context) async {
    _validKisses = widget.validKisses;
    _setUpdateTimer();
  }

  void _setUpdateTimer() {
    _updateKissesTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      final Messages validKisses =
          _validKisses.where(quickKissIsValid).toList();
      if (validKisses.isNotEmpty) {
        for (var kiss in validKisses) {
          if (kiss.kissType != null) {
            final timeLeft = kiss.kissType!.data!.quickKissDuration! - 1;
            for (var currentKiss in _validKisses) {
              final existingKissIndex = validKisses.indexWhere(
                  (element) => element.messageId == currentKiss.messageId);
              if (existingKissIndex > -1) {
                setState(() {
                  _validKisses[existingKissIndex].kissType!.data!.timeLeft =
                      timeLeft;
                });
              }
            }
          }
        }
        return _updateKissesList(validKisses);
      }
      timer.cancel();
      _clearKisses(context);
    });
  }

  void _updateKissesList(Messages updatedKisses) {
    for (var kiss in _validKisses) {
      if (!updatedKisses
          .any((validKiss) => validKiss.messageId == kiss.messageId)) {
        final kissIndex = _validKisses.indexOf(kiss);
        setState(() {
          _listState.currentState?.removeItem(kissIndex,
              (_, animation) => _kissTile(context, kissIndex, animation),
              duration: Duration(milliseconds: 250));
          _validKisses.removeAt(kissIndex);
        });
      }
    }
  }

  _gibBaccAll(BuildContext context) {
    sendBaccAll(context);
    _clearKisses(context);
  }

  _clearKisses([BuildContext? context]) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(Message.quickKiss);
    if (context != null) {
      Navigator.of(context).pop();
    }
  }
}
