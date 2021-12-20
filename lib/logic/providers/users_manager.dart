import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:provider/provider.dart';

class UsersManager extends ChangeNotifier {
  final NullableUsersData _usersData = {};
  bool _isWaitingForToken = false;

  NullableUsersData get usersData => _usersData;

  bool get isWaitingForToken => _isWaitingForToken;

  Future<void> updateUsersData(NullableUsersData users) async {
    for (var user in users.entries) {
      _usersData[user.key] = user.value;
    }
    notifyListeners();
  }

  startSearchingForToken() {
    _isWaitingForToken = true;
    notifyListeners();
  }

  stopSearchingForToken() {
    _isWaitingForToken = false;
    notifyListeners();
  }
}

class UsersDataListenerWidget extends StatelessWidget {
  final Widget Function(BuildContext, Map<String, User?>, Widget?) childBuilder;
  const UsersDataListenerWidget(this.childBuilder, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) =>
      Selector<UsersManager, NullableUsersData>(
          selector: (_, usersProvider) => usersProvider.usersData,
          builder: childBuilder);
}
