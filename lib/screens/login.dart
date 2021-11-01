import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Map<String, User?>? usersData;
  LoginPage({Key? key, this.usersData}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
        name: Routes.setUp, key: ValueKey(Routes.setUp), child: LoginPage());
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, User?> _usersData;

  final Map<String, TextEditingController> _controllers = {
    'me': TextEditingController(),
    'baby': TextEditingController(),
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
    _usersData = context.read<AppStateManager>().usersData;
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
    } else {
      return Scaffold(body: _form(_usersData));
    }
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
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          _input('me', 'Your username here'),
          _input('baby', 'Your baby username here'),
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

  Widget _input(String controllerKey, String hint) {
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
          decoration: InputDecoration(hintText: hint)),
    );
  }

  Future _saveData(Map<String, User?> usersData) async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('saving da data'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.greenAccent));
      final List<Future> futures = [];
      final Map<String, User> users = {};
      for (var element in _controllers.keys) {
        users[element] = User(
            userName: _controllers[element]!.text,
            token: usersData[element]?.token);
        futures.add(setUserData(context, element, users[element]!));
      }
      await Future.wait(futures);
      final provider = Provider.of<AppStateManager>(context, listen: false);
      provider.setUpUserNames(true, users);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('fix your mistakes then we can talk'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
    }
  }
}
