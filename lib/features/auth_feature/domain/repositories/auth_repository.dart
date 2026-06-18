import 'dart:async';

import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get userChanges;
  Future<AppUser?> get currentUser;
  Future<AppUser> signInWithEmail(String email, String password);
  Future<AppUser> signUpWithEmail(String email, String password);
  Future<void> signOut();
}
