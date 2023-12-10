import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  final FirebaseAuth _firebaseInstance;

  AuthDataSource([FirebaseAuth? firebaseAuth])
      : _firebaseInstance = firebaseAuth ?? FirebaseAuth.instance;

  Future<UserCredential> signUp(String email, String password) async {
    final UserCredential userCredential = await _firebaseInstance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  Future<void> signOut() async {
    await _firebaseInstance.signOut();
  }

  Future<UserCredential> signIn(
      {required String email, required String password}) async {
    final UserCredential userCredential = await _firebaseInstance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    final UserCredential userCredential =
        await _firebaseInstance.signInWithProvider(googleProvider);
    return userCredential;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthDataSource &&
        other._firebaseInstance == _firebaseInstance;
  }

  @override
  int get hashCode => _firebaseInstance.hashCode;
}
