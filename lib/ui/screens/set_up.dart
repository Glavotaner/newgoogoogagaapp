import 'package:flutter/material.dart';
import 'package:googoogagaapp/logic/providers/app_state_manager.dart';
import 'package:googoogagaapp/logic/providers/users_manager.dart';
import 'package:googoogagaapp/logic/utils/alerts.dart';
import 'package:googoogagaapp/logic/utils/user_data.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/models/user/user.dart';
import 'package:provider/provider.dart';

class SetUpScreen extends StatefulWidget {
  final NullableUsersData? usersData;

  SetUpScreen({Key? key, this.usersData}) : super(key: key);

  @override
  _SetUpScreenState createState() => _SetUpScreenState();

  static MaterialPage page() => MaterialPage(
      name: Routes.setUp, key: ValueKey(Routes.setUp), child: SetUpScreen());
}

class _SetUpScreenState extends State<SetUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late NullableUsersData _usersData;

  final Map<String, TextEditingController> _controllers = {
    User.me: TextEditingController(),
    User.baby: TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    if (context.watch<AppStateManager>().isInitialized) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('User data set up'),
        ),
        body: _form(_usersData),
      );
    }
    return Scaffold(body: _form(_usersData));
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  void initState() {
    super.initState();
    _usersData = context.read<UsersManager>().usersData;
  }

  Widget _form(NullableUsersData usersData) {
    _controllers.forEach((key, value) {
      _controllers[key]?.text = usersData[key]?.userName ?? '';
    });
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Please put in some usernames please thank you',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          _input(User.me),
          _input(User.baby),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                    onPressed: () => _saveData(usersData),
                    icon: Icon(Icons.save),
                    label: Text(
                      'Save usernames',
                      style: TextStyle(fontSize: 16),
                    )),
              )),
        ],
      ),
    );
  }

  Widget _input(String controllerKey) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: TextFormField(
          controller: _controllers[controllerKey],
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return 'You hab to put in something gooooshuh';
            }
            if (value?.isNotEmpty ?? false) {
              return value!.contains('marinsux') ? 'Forbidden username' : null;
            }
            return null;
          },
          textAlign: TextAlign.center,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
              label: Text(
                  controllerKey == 'me' ? 'My username' : 'Baby username'))),
    );
  }

  // TODO implement updating usernames
  Future _saveData(NullableUsersData usersData) async {
    if (_formKey.currentState!.validate()) {
      showConfirmSnackbar('saving da data');
      final UsersData newUsers = {
        for (var user in _controllers.entries)
          user.key:
              User(userName: user.value.text, token: usersData[user.key]?.token)
      };
      await updateAllUsers(context, newUsers);
      return Provider.of<AppStateManager>(context, listen: false).initialize();
    }
    showErrorSnackbar('fix your errors then we can talk');
  }
}
