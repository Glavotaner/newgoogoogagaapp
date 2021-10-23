import 'package:flutter/material.dart';

Widget buildLoadingScreen([String? message]) {
  final List<Widget> pageData = [const CircularProgressIndicator()];
  if (message != null && message.isNotEmpty) {
    pageData.add(Text(message));
  }
  return Center(
      child: Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: pageData,
  ));
}
