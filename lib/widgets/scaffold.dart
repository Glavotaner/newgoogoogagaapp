import 'package:flutter/material.dart';

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({Key? key, this.body}) : super(key: key);
  final Widget? body;

  @override
  _ScaffoldPageState createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Googoo Gaga App'),
          bottomOpacity: 0,
          centerTitle: true),
      backgroundColor: Colors.white,
      body: widget.body ?? const Placeholder(),
    );
  }
}
