import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:googoogagaapp/screens/home.dart';
import 'package:googoogagaapp/screens/unread.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:provider/provider.dart';

class ScaffoldScreen extends StatefulWidget {
  final List<Widget> pages = [HomePage(), KissArchive()];
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
    bool _refreshDisabled =
        context.watch<UsersManager>().usersData[User.me]?.token == null;

    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                color: Theme.of(context).hintColor,
                onPressed: () =>
                    Provider.of<AppStateManager>(context, listen: false)
                        .enterUsersSetUp(true),
                icon: Icon(Icons.people)),
            IconButton(
                color: Colors.redAccent,
                onPressed:
                    _refreshDisabled ? null : () => refreshBabyToken(context),
                icon: Icon(
                    context.watch<UsersManager>().usersData[User.baby]?.token !=
                            null
                        ? Icons.favorite
                        : Icons.favorite_border))
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
    );
  }
}
