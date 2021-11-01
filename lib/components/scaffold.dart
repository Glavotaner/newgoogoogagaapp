import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:provider/provider.dart';

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({Key? key, this.body}) : super(key: key);
  final Widget? body;

  @override
  _ScaffoldPageState createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  @override
  Widget build(BuildContext context) {
    bool _refreshDisabled =
        context.watch<AppStateManager>().usersData['me']?.token == null;
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                color: Theme.of(context).hintColor,
                onPressed: () =>
                    Provider.of<AppStateManager>(context, listen: false)
                        .setUpUserNames(false),
                icon: Icon(Icons.people)),
            IconButton(
                color: Colors.redAccent,
                onPressed:
                    _refreshDisabled ? null : () => refreshBabyToken(context),
                icon: Icon(
                    context.watch<AppStateManager>().usersData['baby']?.token !=
                            null
                        ? Icons.favorite
                        : Icons.favorite_border))
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