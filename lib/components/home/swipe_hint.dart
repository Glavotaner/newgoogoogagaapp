import 'package:flutter/material.dart';

class SwipeHint extends StatelessWidget {
  final int page;
  final double opacity;
  static final List<Map> _hints = [
    {
      'text': 'swipe oop to select kifs to gib to babba',
      'arrowIcon': Icons.arrow_downward_sharp,
    },
    {
      'text': 'swipe down to ascc for an kiss',
      'arrowIcon': Icons.arrow_upward_sharp,
    },
  ];
  const SwipeHint({Key? key, required this.page, required this.opacity})
      : super(key: key);
  @override
  Widget build(BuildContext context) => AnimatedAlign(
      alignment: page == 0 ? Alignment.bottomCenter : Alignment.topCenter,
      duration: Duration(milliseconds: 100),
      curve: Curves.bounceIn,
      child: Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_hints[page]['arrowIcon']),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _hints[page]['text'],
                    style: const TextStyle(color: Colors.black38),
                  ),
                ),
                Icon(_hints[page]['arrowIcon'])
              ],
            ),
          )));
}
