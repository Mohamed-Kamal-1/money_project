import '../../../../core/errors/result.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<Result<UserCredential>> login({required String email, required String password});
  Future<Result<UserCredential>> register({required String email, required String password});
  Future<Result<void>> logout();
  User? get currentUser;
}
