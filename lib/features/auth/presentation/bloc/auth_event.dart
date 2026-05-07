part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

// Fired internally by the Firebase authStateChanges stream listener.
class AuthStateChangedEvent extends AuthEvent {
  final UserEntity? user;
  const AuthStateChangedEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInWithEmailEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmailEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  const SignUpWithEmailEvent(
      {required this.name, required this.email, required this.password});

  @override
  List<Object> get props => [name, email, password];
}

class SignInWithGoogleEvent extends AuthEvent {
  const SignInWithGoogleEvent();

  @override
  List<Object> get props => [];
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  const ResetPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}
