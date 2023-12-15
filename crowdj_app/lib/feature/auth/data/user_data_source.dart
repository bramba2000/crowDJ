import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdj/feature/auth/models/user_props.dart';

class UserDataSource {
  final FirebaseFirestore _firestore;

  static const String _userPropsCollection = 'users';

  /// Constructor for [UserDataSource]. If no [firestore] is provided, the default instance of [FirebaseFirestore] is used.
  UserDataSource([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserProps> getUserProps(String userId) async {
    final DocumentSnapshot userPropsSnapshot =
        await _firestore.collection(_userPropsCollection).doc(userId).get();
    return UserProps.fromJson(userPropsSnapshot.data() as Map<String, dynamic>);
  }

  Future<void> createUserProps(String userId, UserProps userProps) async {
    await _firestore
        .collection(_userPropsCollection)
        .doc(userId)
        .set(userProps.toJson());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserDataSource && other._firestore == _firestore;
  }

  @override
  int get hashCode => _firestore.hashCode;
}

final defaultUserDataSource = UserDataSource();
