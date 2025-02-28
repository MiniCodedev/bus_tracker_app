part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignInWithEmailPassword extends AuthEvent {
  final String email;
  final String password;

  AuthSignInWithEmailPassword({required this.email, required this.password});
}

final class AuthSignInWithGoogle extends AuthEvent {}

final class AuthUserLoginCheck extends AuthEvent {}

final class AuthUserLogout extends AuthEvent {}
