import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/message.dart';
import 'package:googoogagaapp/components/archive/archive_list.dart';
import 'package:googoogagaapp/components/loading.dart';
import 'package:googoogagaapp/utils/archive.dart';

class KissArchiveScreen extends StatefulWidget {
  const KissArchiveScreen({Key? key}) : super(key: key);

  @override
  _KissArchiveScreenState createState() => _KissArchiveScreenState();
}

class _KissArchiveScreenState extends State<KissArchiveScreen> {
  late Future<List<Message>?> _getArchive;

  @override
  void initState() {
    super.initState();
    _getArchive = getArchive(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getArchive,
      builder: (context, AsyncSnapshot<List<Message>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return KissArchiveList();
        }
        return LoadingScreen(message: 'Loading messages...');
      },
    );
  }
}