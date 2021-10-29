import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:googoogagaapp/utils/messaging.dart';

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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            controller: _textController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: _placeholder),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: ElevatedButton.icon(
                  onPressed: () => _sendRequest(context),
                  icon: Icon(Icons.send_sharp),
                  label: Text('Send request')))
        ],
      ),
    );
  }
}
