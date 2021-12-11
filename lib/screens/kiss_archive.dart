import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/archive/archive_tile.dart';
import 'package:googoogagaapp/components/no_data.dart';
import 'package:googoogagaapp/providers/archive_manager.dart';
import 'package:provider/provider.dart';
import 'package:googoogagaapp/models/message/message.dart';

class KissArchiveScreen extends StatelessWidget {
  const KissArchiveScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Selector<ArchiveManager, Messages>(
      builder: (context, archive, child) {
        if (archive.isNotEmpty) {
          return ListView.builder(
            itemCount: archive.length,
            itemBuilder: (context, int index) {
              return ArchiveTile(archive[index]);
            },
          );
        }
        return NoDataScreen(message: 'There is nofing here!');
      },
      selector: (buildContext, archiveProvider) => archiveProvider.messages);
}
