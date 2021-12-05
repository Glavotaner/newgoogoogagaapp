import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/loading.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:googoogagaapp/screens/home.dart';
import 'package:googoogagaapp/screens/kiss_archive.dart';
import 'package:googoogagaapp/services/services.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/utils/archive.dart';
import 'package:googoogagaapp/utils/initialization.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:googoogagaapp/utils/state.dart';
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

class _ScaffoldScreenState extends State<ScaffoldScreen>
    with WidgetsBindingObserver {
  int _selectedTab = 0;
  bool _showingSnackbar = false;
  late Future<void> _setUpMessaging;
  bool _hideFab = true;

  sendKissBack(BuildContext context) {
    sendKiss(context, KissType.kissBack)
        .catchError((error) => showErrorSnackbar(error));
    if (!_showingSnackbar) {
      _showingSnackbar = true;
      showConfirmSnackbar(KissType.kissBack.confirmMessage)
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      refreshOnAppResumed(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setScaffoldContext(context);
    _setUpMessaging =
        setUpMessaging(context).catchError((error) => showErrorSnackbar(error));
  }

  @override
  Widget build(BuildContext context) {
    // TODO add swipe hint
    return Scaffold(
      appBar: AppBar(
          actions: _appBarButtons(context),
          title: const Text('Googoo Gaga App'),
          bottomOpacity: 0,
          centerTitle: true),
      bottomNavigationBar: _navBar(context),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _setUpMessaging,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return IndexedStack(
                index: _selectedTab,
                children: widget.pages,
              );
            }
            return LoadingScreen(message: 'Setting up messaging...');
          }),
      floatingActionButton: _clearArchiveButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  List<Widget> _appBarButtons(BuildContext context) {
    return [
      IconButton(
          color: Theme.of(context).cardColor,
          onPressed: () => Provider.of<AppStateManager>(context, listen: false)
              .enterUsersSetUp(),
          icon: Icon(Icons.people)),
      Consumer<UsersManager>(
        builder: (context, usersManager, child) {
          // TODO animate scanning for token
          return IconButton(
              color: Colors.redAccent,
              onPressed: usersManager.usersData[User.me]?.token == null
                  ? null
                  : () => refreshBabyToken(context)
                      .catchError((error) => showErrorSnackbar(error)),
              icon: Icon(usersManager.usersData[User.baby]?.token == null
                  ? Icons.favorite_border
                  : Icons.favorite));
        },
      )
    ];
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
        _hideFab = archive.messages.isEmpty || _selectedTab == 0;
        return buildClearFab(context, !_hideFab);
      },
    );
  }

  Widget buildClearFab(BuildContext context, bool visible) =>
      Visibility(child: _buildClearButton(context), visible: visible);

  Widget _buildClearButton(BuildContext context) => FloatingActionButton(
      onPressed: () => clearArchive(context),
      backgroundColor: Colors.redAccent,
      child: Icon(Icons.delete_forever));
}
