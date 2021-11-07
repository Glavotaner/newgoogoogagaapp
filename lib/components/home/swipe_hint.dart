import 'package:flutter/material.dart';

class SwipeHint extends StatelessWidget {
  final double opacity;
  final int page;
  const SwipeHint({Key? key, required this.opacity, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity,
      child: AnimatedCrossFade(
          firstChild: Align(
            alignment: Alignment.bottomCenter,
            child: _buildHintRow('swipe oop to select kifs to git to babba',
                Icons.arrow_downward_rounded),
          ),
          secondChild: Align(
            alignment: Alignment.topCenter,
            child: _buildHintRow('swipe down to ascccc for an kiss maybe',
                Icons.arrow_upward_rounded),
          ),
          duration: const Duration(milliseconds: 50),
          crossFadeState:
              page == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstCurve: Curves.easeOut,
          secondCurve: Curves.easeOut),
    );
  }

  Widget _buildHintRow(String text, IconData arrowIcon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(arrowIcon),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black38),
          ),
        ),
        Icon(arrowIcon)
      ],
    );
  }
}
