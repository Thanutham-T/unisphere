import 'package:equatable/equatable.dart';
import '../../data/models/register_request.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final RegisterRequest request;

  const RegisterRequested({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();
}

class LoadCurrentUserRequested extends AuthEvent {
  const LoadCurrentUserRequested();
}
