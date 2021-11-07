import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:googoogagaapp/screens/home.dart';
import 'package:googoogagaapp/screens/kiss_archive.dart';
import 'package:googoogagaapp/utils/archive.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:provider/provider.dart';

class ScaffoldScreen extends StatefulWidget {
  final List<Widget> pages = [HomeScreen(), KissArchiveScreen()];
  ScaffoldScreen({Key? key}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
      name: Routes.home,
      key: ValueKey(Routes.home),
      child: ScaffoldScreen(),
    );
  }

  @override
  _ScaffoldScreenState createState() => _ScaffoldScreenState();
}

class _ScaffoldScreenState extends State<ScaffoldScreen> {
  int _selectedTab = 0;

  _selectTab(int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                color: Theme.of(context).cardColor,
                onPressed: () =>
                    Provider.of<AppStateManager>(context, listen: false)
                        .setUpUserNames(),
                icon: Icon(Icons.people)),
            Consumer<UsersManager>(
              builder: (context, usersManager, child) {
                return IconButton(
                    color: Colors.redAccent,
                    onPressed: usersManager.usersData[User.me]?.token == null
                        ? null
                        : () => refreshBabyToken(context),
                    icon: Icon(usersManager.usersData[User.baby]?.token == null
                        ? Icons.favorite_border
                        : Icons.favorite));
              },
            )
          ],
          title: const Text('Googoo Gaga App'),
          bottomOpacity: 0,
          centerTitle: true),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          selectedFontSize: 16.0,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: _selectTab,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send kiss'),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive_sharp), label: 'Kiss archive')
          ]),
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedTab,
        children: widget.pages,
      ),
      floatingActionButton: Consumer<ArchiveManager>(
        builder: (context, archive, child) {
          return Visibility(
            visible: _selectedTab == 1 && archive.messages.isNotEmpty,
            child: FloatingActionButton(
                onPressed: () => clearArchive(context),
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.delete_forever)),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
