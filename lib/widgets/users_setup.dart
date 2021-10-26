import 'package:flutter/material.dart';
import 'package:googoogagaapp/models/user.dart';

class UsersSetUpWidget extends StatefulWidget {
  final Map<String, User?> usersData;
  UsersSetUpWidget(this.usersData, {Key? key}) : super(key: key);

  @override
  _UsersSetUpWidgetState createState() => _UsersSetUpWidgetState();
}

class _UsersSetUpWidgetState extends State<UsersSetUpWidget> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Please put in some usernames please thank you'),
        ),
        TextField(
            controller: _textController,
            decoration: InputDecoration(
                hintText: widget.usersData['me'] == null
                    ? 'Please put in your username here'
                    : null)),
        TextField(
            controller: _textController,
            decoration: InputDecoration(
                hintText: widget.usersData['baby'] == null
                    ? 'Please put in baby username here'
                    : null)),
      ],
    );
  }
}
