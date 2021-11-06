import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/alerts.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:googoogagaapp/providers/users_manager.dart';
import 'package:provider/provider.dart';

class SetUpScreen extends StatefulWidget {
  final Map<String, User?>? usersData;
  SetUpScreen({Key? key, this.usersData}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
        name: Routes.setUp, key: ValueKey(Routes.setUp), child: SetUpScreen());
  }

  @override
  _SetUpScreenState createState() => _SetUpScreenState();
}

class _SetUpScreenState extends State<SetUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, User?> _usersData;

  final Map<String, TextEditingController> _controllers = {
    User.me: TextEditingController(),
    User.baby: TextEditingController(),
  };

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

  @override
  Widget build(BuildContext context) {
    if (context.watch<AppStateManager>().isLoggedIn) {
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

  Widget _form(Map<String, User?> usersData) {
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

  Future _saveData(Map<String, User?> usersData) async {
    if (_formKey.currentState!.validate()) {
      showConfirmSnackbar(context, 'saving da data');
      await Future.wait(_controllers.keys.map((user) {
        return setUserData(
            context,
            user,
            User(
                userName: _controllers[user]!.text,
                token: usersData[user]?.token));
      }).toList());
      return Provider.of<AppStateManager>(context, listen: false).logIn();
    }
    return showErrorSnackbar(context, 'fix your errors then we can talk');
  }
}
