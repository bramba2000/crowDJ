import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:crowdj/feature/auth/data/user_data_source.dart';
import 'package:crowdj/feature/auth/models/user_props.dart';
import 'package:crowdj/feature/auth/providers/authentication_provider.dart';
import 'package:crowdj/feature/auth/providers/state/authentication_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<UserDataSource>()])
import 'auth_test.mocks.dart';

void main() {
  group('Test the functionality of the data source', () {
    test('Test user creation', () async {
      final auth = MockFirebaseAuth();
      final authDataSource = AuthDataSource(auth);
      final user = await authDataSource.signUp('test', 'password');
      expect(user, isNotNull);
      expect(user.user, isNotNull);
      expect(user.user!.email, 'test');
    });

    test('Test user sign in', () async {
      var auth = MockFirebaseAuth();
      auth.mockUser = MockUser(
        isAnonymous: false,
        displayName: 'test1',
        email: 'test',
      );
      final authDataSource = AuthDataSource(auth);
      final user =
          await authDataSource.signIn(email: 'test', password: 'password');
      expect(user, isNotNull);
      expect(user.user, isNotNull);
      expect(user.user!.email, 'test');
      expect(user.user!.displayName, 'test1');
    });

    test('Test user sign out', () async {
      var auth = MockFirebaseAuth();
      auth.mockUser = MockUser(
        isAnonymous: false,
        displayName: 'test1',
        email: 'test',
      );
      final authDataSource = AuthDataSource(auth);
      final user =
          await authDataSource.signIn(email: 'test', password: 'password');
      expect(user, isNotNull);
      expect(user.user, isNotNull);
      expect(user.user!.email, 'test');
      expect(user.user!.displayName, 'test1');
      await authDataSource.signOut();
      expect(auth.currentUser, isNull);
    });
  });

  ProviderContainer createContainer({
    ProviderContainer? parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  }) {
    // Create a ProviderContainer, and optionally allow specifying parameters.
    final container = ProviderContainer(
      parent: parent,
      overrides: overrides,
      observers: observers,
    );

    // When the test ends, dispose the container.
    addTearDown(container.dispose);

    return container;
  }

  group('Test auth notifier', () {
    test('Test notify when user login', () async {
      provideDummy(const UserProps(
          name: 'name',
          surname: 'surname',
          email: 'email',
          userType: UserType.PARTICIPANT));
      final auth = MockFirebaseAuth();
      final authDataSource = AuthDataSource(auth);
      final container = createContainer();

      final provider =
          authNotifierProvider(authDataSource, MockUserDataSource());

      expect(container.read(provider), isA<AuthenticationStateInitial>());
      final future =
          container.read(provider.notifier).signIn('test', 'password');
      expect(container.read(provider), isA<AuthenticationStateLoading>());
      await future;
      expect(container.read(provider), isA<AuthenticationStateAuthenticated>());
    });

    test('Test notify when user logoug', () async {
      final auth = MockFirebaseAuth(signedIn: true);
      final authDataSource = AuthDataSource(auth);
      final container = createContainer();

      final provider =
          authNotifierProvider(authDataSource, MockUserDataSource());

      expect(container.read(provider), isA<AuthenticationStateInitial>());
      await container.read(provider.notifier).signOut();
      expect(
          container.read(provider), isA<AuthenticationStateUnauthenticated>());
    });
  });
}
