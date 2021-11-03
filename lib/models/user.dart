class User {
  String userName;
  String? token;

  static String me = 'me';
  static String baby = 'baby';

  User({required this.userName, this.token});

  User.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        token = json['token'];

  Map<String, dynamic> toJson() => {'userName': userName, 'token': token};

  bool get hasToken => token?.isNotEmpty ?? false;
}
