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

    // ✅ جلب الاسم من Firestore إذا كان مخزناً
    final userDoc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    final displayName =
        userDoc.data()?['displayName'] as String? ?? firebaseUser.displayName;

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: displayName,
      photoUrl: firebaseUser.photoURL,
      emailVerifiedAt: firebaseUser.emailVerified ? DateTime.now() : null,
    );
  }

  @override
  Future<AppUser> signUpWithEmail(
    String email,
    String password, [
    String? displayName,
  ]) async {
    final credential = await _remoteDataSource.signUpWithEmail(
      email,
      password,
      displayName ?? '',
    );
    final firebaseUser = credential.user!;

    // ✅ تحديث الـ displayName في Firebase Authentication (اختياري)
    await firebaseUser.updateDisplayName(displayName);

    // ✅ تخزين الاسم في Firestore
    await _firestore.collection('users').doc(firebaseUser.uid).set({
      'balance': 0.0,
      'displayName': displayName ?? '',
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // ✅ إنشاء مستند الإعدادات افتراضياً
    await _firestore.collection('user_settings').doc(firebaseUser.uid).set({
      'darkMode': true,
      'notificationsEnabled': true,
      'currency': 'USD',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: displayName ?? firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      emailVerifiedAt: firebaseUser.emailVerified ? DateTime.now() : null,
    );
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }
}
