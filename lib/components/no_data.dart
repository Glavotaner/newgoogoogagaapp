import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key, this.message}) : super(key: key);
  final String? message;
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
            child: Text(message ?? 'There is nofing here!',
                style: Theme.of(context).textTheme.headline6),
          )
        ],
      ),
    );
  }
}
