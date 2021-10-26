import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';
import 'package:googoogagaapp/utils/user_data.dart';

class UsersSetUpWidget extends StatefulWidget {
  final Map<String, User?> usersData;
  UsersSetUpWidget(this.usersData, {Key? key}) : super(key: key);

  @override
  _UsersSetUpWidgetState createState() => _UsersSetUpWidgetState();
}

class _UsersSetUpWidgetState extends State<UsersSetUpWidget> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'me': TextEditingController(),
    'baby': TextEditingController(),
  };

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllers.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                decoration: InputDecoration(
                    hintText: widget.usersData['me'] == null
                        ? 'Please put in your username here'
                        : null)),
          ),
          Center(
            child: TextFormField(
                controller: _controllers['baby'],
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'You hab to put in something gooooshuh';
                  }
                  if (value?.isNotEmpty ?? false) {
                    return value == '6969marinsux6969'
                        ? 'Forbidden username'
                        : null;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: widget.usersData['baby'] == null
                        ? 'Please put in baby username here'
                        : null)),
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
                      await Future.wait([
                        setUserData(
                            'me', User(userName: _controllers['me']!.text)),
                        setUserData(
                            'baby', User(userName: _controllers['baby']!.text))
                      ]);
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
    );
  }
}
