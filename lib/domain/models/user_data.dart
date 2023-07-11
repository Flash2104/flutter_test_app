import 'package:equatable/equatable.dart';

const AuthUserRequest admin = AuthUserRequest(email: 'admin@test.com', password: 'admin');
const AuthUserRequest manager =
    AuthUserRequest(email: 'manager@test.com', password: 'manager');

class AuthUserRequest extends Equatable {
  final String email;
  final String password;
  const AuthUserRequest({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password, // should be password hash
      ];

  bool validate() {
    final users = [
      admin,
      manager,
    ];
    return users.contains(this);
  }
}

class AuthUserData {
  String? email;
  String? accessToken;
  AuthUserData({
    required this.email,
    required this.accessToken,
  });
  AuthUserData.fromJson(Map<String, dynamic> json) {
    email = json['email'] as String?;
    accessToken = json['accessToken'] as String?;
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'email': email,
      };
}
