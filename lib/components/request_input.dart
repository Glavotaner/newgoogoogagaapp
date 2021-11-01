import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:googoogagaapp/utils/app_state_manager.dart';
import 'package:googoogagaapp/utils/messaging.dart';
import 'package:provider/provider.dart';

class KissRequest extends StatefulWidget {
  const KissRequest({Key? key}) : super(key: key);

  @override
  _KissRequestState createState() => _KissRequestState();
}

class _KissRequestState extends State<KissRequest> {
  final _textController = TextEditingController();
  static const _placeholder = 'I am babby and I ask for kiss';

  _sendRequest(BuildContext context) {
    sendRequest(context,
        _textController.text.isNotEmpty ? _textController.text : _placeholder);
    _textController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _disableButton = false;
    context.watch<AppStateManager>().usersData.forEach((key, value) {
      if (value?.token == null) {
        _disableButton = true;
      }
    });
    return Container(
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
              child: ElevatedButton.icon(
                  onPressed:
                      _disableButton ? null : () => _sendRequest(context),
                  onLongPress: null,
                  icon: Icon(Icons.send_sharp),
                  label: Text('Send request', style: TextStyle(fontSize: 16))))
        ],
      ),
    );
  }
}
