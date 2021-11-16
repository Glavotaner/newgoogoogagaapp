import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/archive/archive_list.dart';
import 'package:googoogagaapp/components/loading.dart';
import 'package:googoogagaapp/utils/archive.dart';

class KissArchiveScreen extends StatefulWidget {
  const KissArchiveScreen({Key? key}) : super(key: key);

  @override
  _KissArchiveScreenState createState() => _KissArchiveScreenState();
}

class _KissArchiveScreenState extends State<KissArchiveScreen>
    with WidgetsBindingObserver {
  late Future<void> _getArchive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _getArchive = getArchive(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getArchive(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getArchive,
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return KissArchiveList();
        }
        // TODO instead of this, incorporate init in splash page
        return LoadingScreen(message: 'Loading messages...');
      },
    );
  }
}
