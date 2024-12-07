import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String userId;
  final String password;

  RegisterEvent({required this.userId, required this.password});

  @override
  List<Object?> get props => [userId, password];
}

class LoginEvent extends AuthEvent {
  final String userId;
  final String password;

  LoginEvent({required this.userId, required this.password});

  @override
  List<Object?> get props => [userId, password];
}
