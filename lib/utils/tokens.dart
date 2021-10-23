import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getToken(String name) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  return sharedPreferences.getString(name);
}

setToken(String name, String token) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await sharedPreferences.setString(name, token);
}

Future<bool> checkTokenExists(String name) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final String? token = sharedPreferences.getString(name);
  return token != null && token.isNotEmpty;
}

Future sendRefreshedToken(String token) async {
  return Future(() => true);
}
