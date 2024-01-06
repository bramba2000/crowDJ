import '../../models/user_props.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthenticationState {}

class AuthenticationStateInitial extends AuthenticationState {}

/// The auth is chainging state
/// This is used when the app is checking if the user is authenticated or not. If this should be a final result consider use of `await` or `FutureBuilder`
class AuthenticationStateLoading extends AuthenticationState {}

/// A user is logged in
class AuthenticationStateAuthenticated extends AuthenticationState {
  final User user;
  final UserProps userProps;
  AuthenticationStateAuthenticated(
      {required this.user, required this.userProps});
}

/// No user is logged in
/// Consider inspecting the [AutehnticationStateUnauthenticated.message] for more information about the reason of the unauthenticated state
class AuthenticationStateUnauthenticated extends AuthenticationState {
  final Exception exception;

  String get message => exception.toString();
  AuthenticationStateUnauthenticated(this.exception);
}
