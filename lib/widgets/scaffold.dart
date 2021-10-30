import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/initialization.dart';

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
          actions: [
            IconButton(
                color: Colors.redAccent,
                onPressed: () => refreshBabyToken(context),
                icon: Icon(Icons.favorite))
          ],
          title: const Text('Googoo Gaga App'),
          bottomOpacity: 0,
          centerTitle: true),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send kiss'),
        BottomNavigationBarItem(
            icon: Icon(Icons.archive_sharp), label: 'Kiss archive')
      ]),
      backgroundColor: Colors.white,
      body: widget.body ?? const Placeholder(),
    );
  }
}
