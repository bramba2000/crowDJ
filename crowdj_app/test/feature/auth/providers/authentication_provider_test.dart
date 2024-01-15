import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:crowdj/feature/auth/data/user_data_source.dart';
import 'package:crowdj/feature/auth/models/user_props.dart';
import 'package:crowdj/feature/auth/providers/authentication_provider.dart';
import 'package:crowdj/feature/auth/providers/state/authentication_state.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<UserDataSource>()])
import 'authentication_provider_test.mocks.dart';

void main() {
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
    test('Test notifier logic when user login', () async {
      final mockUser = MockUser(
        isAnonymous: false,
        displayName: 'test1',
        email: 'test@test.it',
        uid: 'test123456',
      );
      const mockUserProps = UserProps(
          name: 'name',
          surname: 'surname',
          email: 'test@test.it',
          userType: UserType.participant);

      provideDummy(mockUserProps);

      final auth = MockFirebaseAuth(mockUser: mockUser);
      final mockAuthDataSource = AuthDataSource(auth);

      final mockUserDataSource = MockUserDataSource();
      when(mockUserDataSource.getUserProps(any))
          .thenAnswer((_) async => mockUserProps);

      final container = createContainer();

      final provider =
          authNotifierProvider(mockAuthDataSource, mockUserDataSource);

      expect(container.read(provider), isA<AuthenticationStateInitial>());
      final future =
          container.read(provider.notifier).signIn('test', 'password');
      expect(container.read(provider), isA<AuthenticationStateLoading>());
      await future;
      expect(container.read(provider), isA<AuthenticationStateAuthenticated>());
      // two calls because one for the initial state build and one for the login
      verify(mockUserDataSource.getUserProps(mockUser.uid)).called(2);
    });

    test('Test notifyier logic when user sign up', () async {
      final mockUser = MockUser(
        isAnonymous: false,
        displayName: 'test1',
        email: 'test@test.it',
        uid: 'test123456',
      );
      const mockUserProps = UserProps(
          name: 'name',
          surname: 'surname',
          email: 'test@test.it',
          userType: UserType.participant);

      const mockUserProps2 = UserProps(
          name: 'name',
          surname: 'surname',
          email: 'test@test.it',
          userType: UserType.participant);
      expect(mockUserProps2, equals(mockUserProps));

      provideDummy(mockUserProps);

      final auth = MockFirebaseAuth(mockUser: mockUser);
      final mockAuthDataSource = AuthDataSource(auth);

      final mockUserDataSource = MockUserDataSource();
      when(mockUserDataSource.getUserProps(any))
          .thenAnswer((_) async => mockUserProps);

      final container = createContainer();

      final provider =
          authNotifierProvider(mockAuthDataSource, mockUserDataSource);

      expect(container.read(provider), isA<AuthenticationStateInitial>());
      final future = container.read(provider.notifier).signUp(
          mockUserProps.name,
          mockUserProps.surname,
          mockUserProps.email,
          'password',
          mockUserProps.userType);
      expect(container.read(provider), isA<AuthenticationStateLoading>());
      await future;
      expect(container.read(provider), isA<AuthenticationStateAuthenticated>());
      final newUser = auth.currentUser;
      verify(mockUserDataSource.createUserProps(
              newUser?.uid, argThat(equals(mockUserProps))))
          .called(1);
    });

    test('Test notifier logic when user log out', () async {
      final auth = MockFirebaseAuth(signedIn: true);
      final authDataSource = AuthDataSource(auth);
      final container = createContainer();

      final provider =
          authNotifierProvider(authDataSource, MockUserDataSource());

      await container.read(provider.notifier).signOut();
      expect(container.read(provider), isA<AuthenticationStateInitial>());
    });
  });
}
