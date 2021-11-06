import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';

class KissSelectionScreen extends StatelessWidget {
  const KissSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _kissTypes = buildKissTypes();
    return PageView(
      scrollDirection: Axis.horizontal,
      children: _kissTypes,
    );
  }
}
