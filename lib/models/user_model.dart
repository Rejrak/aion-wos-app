class User {
  final String userId;
  final String password;

  User({required this.userId, required this.password});

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'password': password,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    userId: map['userId'],
    password: map['password'],
  );
}

class UserSession {
  static final UserSession _instance = UserSession._internal();
  String? userId;

  factory UserSession() => _instance;

  UserSession._internal();
}