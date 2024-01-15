import 'package:crowdj/feature/auth/data/user_data_source.dart';
import 'package:crowdj/feature/auth/models/user_props.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test user data source functionality', () {
    test('Test retrieve of user proprs', () async {
      const UserProps userProps = UserProps(
          name: 'name',
          surname: 'surname',
          email: 'email',
          userType: UserType.participant);
      final firestore = FakeFirebaseFirestore();
      await firestore
          .collection('users')
          .doc(userProps.email)
          .set(userProps.toJson());
      final UserDataSource userDataSource = UserDataSource(firestore);
      final props = userDataSource.getUserProps(userProps.email);
      expect(props, isNotNull);
    });

    test('Test creation of user props', () async {
      const UserProps userProps = UserProps(
          name: 'name',
          surname: 'surname',
          email: 'email',
          userType: UserType.participant);
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
}
