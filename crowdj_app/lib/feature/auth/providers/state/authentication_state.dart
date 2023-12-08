import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
sealed class AuthenticationState {}

class AuthenticationStateInitial extends AuthenticationState {}

class AuthenticationStateLoading extends AuthenticationState {}

class AuthenticationStateAuthenticated extends AuthenticationState {
  final User user;
  AuthenticationStateAuthenticated({required this.user});
}

class AuthenticationStateUnauthenticated extends AuthenticationState {
  final String message;
  AuthenticationStateUnauthenticated({required this.message});
}
