import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
