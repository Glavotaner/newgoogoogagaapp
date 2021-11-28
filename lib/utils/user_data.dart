import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:googoogagaapp/models/user/user_repo.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:provider/provider.dart';

/// Sets [userData] for user [name] in shared preferences. Updates user data in user manager provider.
Future setUserData(BuildContext context, String name, User userData) async {
  await updateUser(name, userData);
  Provider.of<UsersManager>(context, listen: false)
      .updateUserNames({name: userData});
}

/// Checks if any user's data is null. If so, navigates to users set up page.
/// This should only happen on first use of the app.
/// Otherwise stores user data from shared preferences in the users manager provider and navigates to home page.
Future<void> checkUsernamesSetUp(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  final state = Provider.of<AppStateManager>(context, listen: false);
  final users = Provider.of<UsersManager>(context, listen: false);
  final usersData = {
    User.me: (await getUserIfExists(User.me)),
    User.baby: (await getUserIfExists(User.baby))
  };
  if (usersData.containsValue(null)) {
    return state.finishLoading();
  }
  users.updateUserNames(usersData);
  state.logIn();
}

/// Checks whether any user in [usersData] is missing a token.
/// This is used to toggle the ability to send messages, or request tokens.
bool anyTokenMissing(NullableUsersData usersData) {
  return usersData.values.any((user) {
    if (user != null) {
      return !user.hasToken;
    }
    return true;
  });
}
