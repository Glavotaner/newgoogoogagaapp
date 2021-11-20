import 'dart:convert';

class User {
  String userName;
  String? token;

  static String me = 'me';
  static String baby = 'baby';
  static String searchingForToken = 'searchingForToken';

  User({required this.userName, this.token});

  User.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        token = json['token'];

  Map<String, dynamic> toJson() => {'userName': userName, 'token': token};

  @override
  String toString() => jsonEncode(toJson());

  bool get hasToken => (token ?? '').isNotEmpty;
}
