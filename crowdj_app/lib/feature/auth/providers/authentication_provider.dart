import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:crowdj/feature/auth/providers/state/authentication_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthenticationState build(AuthDataSource firebaseAuth) {
    return AuthenticationStateInitial();
  }

  Future<void> signIn(String email, String password) async {
    state = AuthenticationStateLoading();
    try {
      final UserCredential userCredential =
          await firebaseAuth.signIn(email: email, password: password);
      state = AuthenticationStateAuthenticated(user: userCredential.user!);
    } on Exception catch (e) {
      state = AuthenticationStateUnauthenticated(message: e.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    state = AuthenticationStateLoading();
    try {
      final UserCredential userCredential =
          await firebaseAuth.signUp(email, password);
      state = AuthenticationStateAuthenticated(user: userCredential.user!);
    } on Exception catch (e) {
      state = AuthenticationStateUnauthenticated(message: e.toString());
    }
  }

  Future<void> signOut() async {
    state = AuthenticationStateLoading();
    try {
      await firebaseAuth.signOut();
      state = AuthenticationStateUnauthenticated(message: 'Signed out');
    } on Exception catch (e) {
      state = AuthenticationStateUnauthenticated(message: e.toString());
    }
  }
}
