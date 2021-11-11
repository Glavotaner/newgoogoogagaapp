import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:googoogagaapp/providers/quick_kiss_manager.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:googoogagaapp/screens/home.dart';
import 'package:googoogagaapp/screens/kiss_archive.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/archive.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:googoogagaapp/utils/messaging.dart';
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
  final _quickKissManager = QuickKissManager();
  int _selectedTab = 0;
  bool _showingSnackbar = false;

  sendKissBack(BuildContext context) {
    sendKiss(context, KissType.kissBack);
    if (!_showingSnackbar) {
      _showingSnackbar = true;
      showConfirmSnackbar(context, KissType.kissBack.confirmMessage)
          .closed
          .then((_) => _showingSnackbar = false);
    }
  }

  _selectTab(int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _quickKissManager,
        child: Scaffold(
          appBar: AppBar(
              leading: _kissTimer(context),
              actions: _appBarButtons(context),
              title: const Text('Googoo Gaga App'),
              bottomOpacity: 0,
              centerTitle: true),
          bottomNavigationBar: _navBar(context),
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: _selectedTab,
            children: widget.pages,
          ),
          floatingActionButton: _clearArchiveButton(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));
  }

  List<Widget> _appBarButtons(BuildContext context) {
    return [
      IconButton(
          color: Theme.of(context).cardColor,
          onPressed: () => Provider.of<AppStateManager>(context, listen: false)
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
    ];
  }

  Widget _kissTimer(BuildContext context) {
    return Consumer<QuickKissManager>(builder: (context, kissManager, child) {
      return Visibility(
        visible: kissManager.minutesLeft > 0,
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Material(
            child: InkWell(
              onTap: () => sendKissBack(context),
              child: Stack(
                children: [
                  Text(kissManager.minutesLeft.toString()),
                  CircularProgressIndicator(
                      color: Colors.white,
                      value: kissManager.minutesLeft /
                          kissManager.duration.inMinutes)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _navBar(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _selectedTab,
        selectedFontSize: 16.0,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: _selectTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send kiss'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_sharp), label: 'Kiss archive')
        ]);
  }

  Widget _clearArchiveButton(BuildContext context) {
    return Consumer<ArchiveManager>(
      builder: (context, archive, child) {
        return Visibility(
          visible: _selectedTab == 1 && archive.messages.isNotEmpty,
          child: FloatingActionButton(
              onPressed: () => clearArchive(context),
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.delete_forever)),
        );
      },
    );
  }
}
