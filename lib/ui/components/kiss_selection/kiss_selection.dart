import 'package:flutter/material.dart';
import 'package:googoogagaapp/logic/providers/users_manager.dart';
import 'package:googoogagaapp/logic/utils/user_data.dart';
import 'package:googoogagaapp/models/kiss_type.dart';

class KissSelectionScreen extends StatelessWidget {
  final double opacity;
  const KissSelectionScreen(this.opacity, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      UsersDataListenerWidget((_, usersData, __) {
        final disabled = anyTokenMissing(usersData);
        return Opacity(
          opacity: opacity,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  children: buildKissTypes(disabled),
                ),
              )
            ],
          ),
        );
      });
}
