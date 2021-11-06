import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getArchive() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences
          .getStringList('messages')
          ?.map((message) => jsonDecode(message) as Map<String, dynamic>)
          .toList() ??
      [];
}
