import 'package:flutter/material.dart';

class NoDataScreen extends StatelessWidget {
  final String? message;

  const NoDataScreen({Key? key, this.message = 'There is no data here!'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Icon(Icons.visibility_off, size: 46.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(message!, style: Theme.of(context).textTheme.headline6),
          )
        ],
      ),
    );
  }
}
