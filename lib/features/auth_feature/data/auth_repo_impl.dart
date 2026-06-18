import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../domain/auth_repo.dart';
import '../domain/entities/app_user.dart';
import 'datasources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._remoteDataSource, this._firestore);

  @override
  Stream<AppUser?> get userChanges {
    return _remoteDataSource.userChanges.map((firebaseUser) {
      if (firebaseUser == null) return null;
      return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        emailVerifiedAt: firebaseUser.emailVerified ? DateTime.now() : null,
      );
    });
  }

  @override
  Future<AppUser?> get currentUser async {
    final firebaseUser = _remoteDataSource.currentUser;
    if (firebaseUser == null) return null;
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      emailVerifiedAt: firebaseUser.emailVerified ? DateTime.now() : null,
    );
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    final credential = await _remoteDataSource.signInWithEmail(email, password);
    final firebaseUser = credential.user!;
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      emailVerifiedAt: firebaseUser.emailVerified ? DateTime.now() : null,
    );
  }

  @override
  Future<AppUser> signUpWithEmail(String email, String password) async {
    final credential = await _remoteDataSource.signUpWithEmail(email, password);
    final firebaseUser = credential.user!;

    // ✅ إنشاء مستند المستخدم في Firestore (للرصيد والإعدادات)
    await _firestore.collection('users').doc(firebaseUser.uid).set({
      'balance': 0.0,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    // ✅ إنشاء مستند الإعدادات افتراضياً (اختياري)
    await _firestore.collection('user_settings').doc(firebaseUser.uid).set({
      'darkMode': true,
      'notificationsEnabled': true,
      'currency': 'USD',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }
}
