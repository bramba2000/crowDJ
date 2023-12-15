import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:crowdj/feature/auth/data/user_data_source.dart';
import 'package:crowdj/feature/auth/models/user_props.dart';
import 'package:crowdj/feature/auth/providers/state/authentication_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_provider.g.dart';

/// [AuthNotifier] is a riverpod [NotifierProvider] that manage the authentication state of the application.
/// It provides methods for signing in and signing up a user using email and password.
/// The state of authentication is updated based on the success or failure of these operations.
///
/// see also [AuthenticationState]
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthenticationState build(
      AuthDataSource firebaseAuth, UserDataSource userDataSource) {
    return AuthenticationStateInitial();
  }

  Future<void> signIn(String email, String password) async {
    state = AuthenticationStateLoading();
    try {
      final UserCredential userCredential =
          await firebaseAuth.signIn(email: email, password: password);
      final UserProps userProps =
          await userDataSource.getUserProps(userCredential.user!.uid);
      state = AuthenticationStateAuthenticated(
          user: userCredential.user!, userProps: userProps);
    } on Exception catch (e) {
      state = AuthenticationStateUnauthenticated(message: e.toString());
    }
  }

  Future<void> signUp(String name, String surname, String email,
      String password, UserType userType) async {
    state = AuthenticationStateLoading();
    try {
      final UserCredential userCredential =
          await firebaseAuth.signUp(email, password);
      final UserProps userProps = UserProps(
          name: name, surname: surname, email: email, userType: userType);
      await userDataSource.createUserProps(userCredential.user!.uid, userProps);
      state = AuthenticationStateAuthenticated(
        user: userCredential.user!,
        userProps: userProps,
      );
    } on Exception catch (e) {
      state = AuthenticationStateUnauthenticated(message: e.toString());
    }
  }

  Future<void> signOut() async {
    state = AuthenticationStateLoading();
    try {
      await firebaseAuth.signOut();
      state = AuthenticationStateUnauthenticated(
          message: 'User signed out with regular method');
    } on Exception catch (e) {
      state = AuthenticationStateUnauthenticated(message: e.toString());
    }
  }
}
