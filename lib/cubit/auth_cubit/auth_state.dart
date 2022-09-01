import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthCodeSentState extends AuthState {}

class AuthCodeVerifiedState extends AuthState {}

class AuthLoggedInState extends AuthState {
  User firebaseUser;
  AuthLoggedInState(this.firebaseUser);
}

class AuthLoggedOutState extends AuthState {}

class AuthErrorState extends AuthState {
  String message;
  AuthErrorState(this.message);
}
