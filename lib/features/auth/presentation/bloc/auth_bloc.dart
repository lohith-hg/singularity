import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:singularity/core/error/exceptions.dart';
import 'package:singularity/core/usecases/usecase.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import 'package:singularity/features/auth/domain/usecases/get_auth_state.dart';
import 'package:singularity/features/auth/domain/usecases/reset_password.dart';
import 'package:singularity/features/auth/domain/usecases/sign_in_email.dart';
import 'package:singularity/features/auth/domain/usecases/sign_in_google.dart';
import 'package:singularity/features/auth/domain/usecases/sign_out.dart';
import 'package:singularity/features/auth/domain/usecases/sign_up_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAuthState getAuthState;
  final SignInWithEmailUseCase signInWithEmail;
  final SignUpWithEmailUseCase signUpWithEmail;
  final SignInWithGoogleUseCase signInWithGoogle;
  final SignOutUseCase signOut;
  final ResetPasswordUseCase resetPassword;

  StreamSubscription<UserEntity?>? _authSub;

  AuthBloc({
    required this.getAuthState,
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signInWithGoogle,
    required this.signOut,
    required this.resetPassword,
  }) : super(const AuthInitial()) {
    on<AuthStateChangedEvent>(_onAuthStateChanged);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<ResetPasswordEvent>(_onResetPassword);

    _authSub = getAuthState(
      NoParams(),
    ).listen((user) => add(AuthStateChangedEvent(user)));
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }

  void _onAuthStateChanged(
    AuthStateChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await signInWithEmail(
        SignInWithEmailParams(email: event.email, password: event.password),
      );
      // Navigation is handled by the AuthStateChangedEvent that fires
      // automatically when Firebase updates the auth state.
    } catch (e) {
      emit(_mapError(e));
    }
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await signUpWithEmail(
        SignUpWithEmailParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );
    } catch (e) {
      emit(_mapError(e));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await signInWithGoogle();
    } catch (e) {
      emit(_mapError(e));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    try {
      await signOut(NoParams());
      // AuthUnauthenticated will be emitted via AuthStateChangedEvent stream.
    } catch (e) {
      emit(_mapError(e));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await resetPassword(event.email);
      emit(const PasswordResetEmailSent());
    } catch (e) {
      emit(_mapError(e));
    }
  }

  AuthError _mapError(Object e) {
    if (e is AuthException) {
      return AuthError(message: e.message, field: _fieldFromCode(e.code));
    }
    return AuthError(message: e.toString());
  }

  String? _fieldFromCode(String? code) {
    switch (code) {
      case 'email-already-in-use':
      case 'user-not-found':
      case 'invalid-email':
        return 'email';
      case 'weak-password':
      case 'wrong-password':
        return 'password';
      default:
        return null;
    }
  }
}
