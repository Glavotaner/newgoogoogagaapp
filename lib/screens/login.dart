import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/screens/loading.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
import 'package:googoogagaapp/utils/user_data.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Map<String, User?>? usersData;
  LoginPage({Key? key, this.usersData}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
        name: 'Login', key: ValueKey('Login'), child: LoginPage());
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late Future<Map<String, User?>?> _usersData;

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
    _usersData = checkUsernamesSetUp(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _usersData,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _form(snapshot.data);
        }
        return LoadingScreen(message: 'Checking login data...');
      },
    );
  }

  Widget _form(Map<String, User?> usersData) {
    _controllers.forEach((key, value) {
      _controllers[key]?.text = usersData[key]?.userName ?? '';
    });
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Please put in some usernames please thank you'),
            ),
            Center(
              child: TextFormField(
                  controller: _controllers['me'],
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'You hab to put in something gooooshuh';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      hintText: 'Please put in your username here')),
            ),
            Center(
              child: TextFormField(
                  controller: _controllers['baby'],
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'You hab to put in something gooooshuh';
                    }
                    if (value?.isNotEmpty ?? false) {
                      return value!.contains('marinsux')
                          ? 'Forbidden username'
                          : null;
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      hintText: 'Please put in baby username here')),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('saving da data'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.greenAccent));
                        await Future.wait(_controllers.keys.map((user) =>
                            setUserData(
                                user,
                                User(
                                    userName: _controllers[user]!.text,
                                    token: usersData[user]?.token))));
                        Provider.of<AppStateManager>(context, listen: false)
                            .setUpUserNames(true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('fix your mistakes then we can talk'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    child: Text('Save usernames')))
          ],
        ),
      ),
    );
  }
}
