import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:crowdj/feature/auth/data/user_data_source.dart';
import 'package:crowdj/feature/auth/models/user_props.dart';
import 'package:crowdj/feature/auth/providers/authentication_provider.dart';
import 'package:crowdj/feature/auth/providers/state/authentication_state.dart';

@GenerateNiceMocks([MockSpec<UserDataSource>()])
import 'auth_test.mocks.dart';

void main() {
  group('Test auth data source functionality', () {
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

  group('Test user data source functionality', () {
    test('Test retrieve of user proprs', () async {
      const UserProps userProps = UserProps(
          name: 'name',
          surname: 'surname',
          email: 'email',
          userType: UserType.PARTICIPANT);
      final firestore = FakeFirebaseFirestore();
      await firestore
          .collection('users')
          .doc(userProps.email)
          .set(userProps.toJson());
      final UserDataSource userDataSource = UserDataSource(firestore);
      final props = userDataSource.getUserProps(userProps.email);
      expect(props, isNotNull);
    });

    test('Test creation of user proprs', () async {
      const UserProps userProps = UserProps(
          name: 'name',
          surname: 'surname',
          email: 'email',
          userType: UserType.PARTICIPANT);
      final firestore = FakeFirebaseFirestore();
      final UserDataSource userDataSource = UserDataSource(firestore);
      await userDataSource.createUserProps('test123456', userProps);
      expect(
          (await firestore.collection('users').doc('test123456').get()).exists,
          true);
      expect(
          (await firestore.collection('users').doc('test1234567').get()).exists,
          false);
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
          userType: UserType.PARTICIPANT);

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
      verify(mockUserDataSource.getUserProps(mockUser.uid)).called(1);
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
          userType: UserType.PARTICIPANT);

      const mockUserProps2 = UserProps(
          name: 'name',
          surname: 'surname',
          email: 'test@test.it',
          userType: UserType.PARTICIPANT);
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

      expect(container.read(provider), isA<AuthenticationStateInitial>());
      await container.read(provider.notifier).signOut();
      expect(
          container.read(provider), isA<AuthenticationStateUnauthenticated>());
    });
  });
}
