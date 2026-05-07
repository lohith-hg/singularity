part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object> get props => [];
}

// `field` is 'email', 'password', or null (general error).
class AuthError extends AuthState {
  final String message;
  final String? field;
  const AuthError({required this.message, this.field});

  @override
  List<Object?> get props => [message, field];
}

class PasswordResetEmailSent extends AuthState {
  const PasswordResetEmailSent();

  @override
  List<Object> get props => [];
}
