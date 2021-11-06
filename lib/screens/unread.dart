import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/no_data.dart';
import 'package:googoogagaapp/screens/loading.dart';
import 'package:googoogagaapp/utils/archive.dart';

class KissArchive extends StatefulWidget {
  const KissArchive({Key? key}) : super(key: key);

  @override
  _KissArchiveState createState() => _KissArchiveState();
}

class _KissArchiveState extends State<KissArchive> {
  final Future<List<Map<String, dynamic>>?> _getArchive = getArchive();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getArchive,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            return _listView(snapshot.data!);
          }
          return NoDataWidget();
        }
        return LoadingScreen(message: 'Loading messages...');
      },
    );
  }

  _listView(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int index) {
        return ListTile(
          title: Text(data[index]['notification']['title']),
        );
      },
    );
  }
}
