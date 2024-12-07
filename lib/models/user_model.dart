class UserModel {
  final String id;
  final String password;

  UserModel({required this.id, required this.password});

  Map<String, dynamic> toJson() => {
    'id': id,
    'password': password,
  };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    password: json['password'],
  );
}
