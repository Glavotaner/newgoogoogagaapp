import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:googoogagaapp/logic/providers/users_manager.dart';
import 'package:googoogagaapp/logic/utils/messaging.dart';
import 'package:googoogagaapp/logic/utils/user_data.dart';

class KissRequest extends StatefulWidget {
  const KissRequest({Key? key}) : super(key: key);

  @override
  _KissRequestState createState() => _KissRequestState();
}

class _KissRequestState extends State<KissRequest> {
  final _textController = TextEditingController();
  static const _placeholder = 'I am babby and I ask for kiss';

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _textController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: _placeholder),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: UsersDataListenerWidget((_, usersData, __) {
                  final bool _disabled = anyTokenMissing(usersData);
                  return ElevatedButton.icon(
                      onPressed: _disabled ? null : () => _sendRequest(context),
                      onLongPress: null,
                      icon: Icon(Icons.send_sharp),
                      label:
                          Text('Send request', style: TextStyle(fontSize: 16)));
                }))
          ],
        ),
      ),
    );
  }

  _sendRequest(BuildContext context) {
    sendRequest(context,
        _textController.text.isNotEmpty ? _textController.text : _placeholder);
    _textController.clear();
  }
}
