import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/kiss_type.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:provider/provider.dart';

class KissSelectionScreen extends StatelessWidget {
  const KissSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersManager>(builder: (context, users, child) {
      final disabled = checkAnyTokenMissing(users.usersData);
      return Column(
        children: [
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: buildKissTypes(disabled),
            ),
          ),
        ],
      );
    });
  }
}
