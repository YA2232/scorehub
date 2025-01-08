part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoadingAuth extends AuthState {}

class SuccessAuth extends AuthState {}

class ErrorAuth extends AuthState {
  final FirebaseAuthException error;
  ErrorAuth({required this.error});
}
