import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/firebase_executor.dart';
import '../../../../core/errors/result.dart';
import '../domain/auth_repo.dart';
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<Result<UserCredential>> login(
      {required String email, required String password}) async {
    return await executeFirebase(() async {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  @override
  Future<Result<UserCredential>> register(
      {required String email, required String password}) async {
    return await executeFirebase(() async {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  @override
  Future<Result<void>> logout() async {
    return await executeFirebase(() => _firebaseAuth.signOut());
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;
}