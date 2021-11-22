import 'package:flutter/material.dart';
import 'package:googoogagaapp/utils/quick_kiss.dart';

class QuickKiss extends StatefulWidget {
  final bool disabled;
  QuickKiss({Key? key, this.disabled = false}) : super(key: key);

  @override
  _QuickKissState createState() => _QuickKissState();
}

class _QuickKissState extends State<QuickKiss> {
  double _sliderValue = 10.0;
  _sendKiss(double duration) async {
    sendQuickKiss(context, duration);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 3,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Placeholder(),
                ),
              ),
              Slider(
                thumbColor: Colors.redAccent,
                label: '${_sliderValue.toInt()} mins',
                value: _sliderValue,
                min: 10,
                max: 60,
                divisions: 5,
                onChanged: (slider) => setState(() {
                  _sliderValue = slider;
                }),
                onChangeEnd: widget.disabled ? null : _sendKiss,
              ),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Quick kiss',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.black54))),
            ],
          ),
        ],
      ),
    );
  }
}
