import '../data/auth_data_source.dart';
import '../data/user_data_source.dart';
import '../models/user_props.dart';
import 'state/authentication_state.dart';
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
    firebaseAuth
        .streamAuthStateChanges()
        .asyncMap((user) async => user == null
            ? (null, null)
            : (user, await userDataSource.getUserProps(user.uid)))
        .listen((rec) {
      if (rec.$1 != null && rec.$2 != null) {
        state =
            AuthenticationStateAuthenticated(user: rec.$1!, userProps: rec.$2!);
      } else if (rec.$1 != null && rec.$2 == null) {
        state = AuthenticationStateUnauthenticated(
            Exception('User props not found'));
      }
    });
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
      state = AuthenticationStateUnauthenticated(e);
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
      state = AuthenticationStateUnauthenticated(e);
    }
  }

  Future<void> signOut() async {
    state = AuthenticationStateLoading();
    try {
      await firebaseAuth.signOut();
      state = AuthenticationStateInitial();
    } on Exception catch (e) {
      state = AuthenticationStateUnauthenticated(e);
    }
  }

  Future<void> authenticateWithSpotify() async {
    try {
      final User user = firebaseAuth.currentUser!;
      final UserProps userProps = await userDataSource.getUserProps(user.uid);
      if (userProps is DjUserProps) {
        final temp = userProps.copyWith(spotifyAuthenticated: true);
        await userDataSource.updateUserProps(user.uid, temp);
        state = AuthenticationStateAuthenticated(
          user: user,
          userProps: temp,
        );
      } else {
        state = AuthenticationStateUnauthenticated(
            Exception('User is not a DJ and cannot authenticate with Spotify'));
      }
    } on Exception catch (e) {
      state = AuthenticationStateUnauthenticated(e);
    }
  }
}
