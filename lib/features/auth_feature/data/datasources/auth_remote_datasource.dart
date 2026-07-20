import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:injectable/injectable.dart';

@injectable
class AuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource(this._firebaseAuth);

  Stream<firebase.User?> get userChanges => _firebaseAuth.userChanges();

  firebase.User? get currentUser => _firebaseAuth.currentUser;

  Future<firebase.UserCredential> signInWithEmail(
    String email,
    String password,
  ) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<firebase.UserCredential> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
