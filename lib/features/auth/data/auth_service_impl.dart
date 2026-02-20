
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../model/user_model.dart';
import '../uer_dto.dart';

class AuthServiceImpl extends ChangeNotifier {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final User? _fbAuthUser = FirebaseAuth.instance.currentUser;
  static final _google = GoogleSignIn.instance;
  static bool isInitialize = false;
  UserModel? _databaseUser;

  Future<void> retrieveUserFormDatabase() async {
    if (_fbAuthUser != null) {
      _databaseUser = await UserDto.getUserById(_fbAuthUser.uid);
      notifyListeners();
    }
  }
  Future<void> loadUserAfterLogin(String userId) async {
    if (_fbAuthUser != null) {
      _databaseUser = await UserDto.getUserById(userId);
      notifyListeners();
    }
  }

  static Future<void> _initSignIn() async {
    if (!isInitialize) {
      _google.initialize(
        serverClientId:
            "786178836835-002q4712cur5dqta3gf7g5l0fu8mt91n.apps.googleusercontent.com",
      );
    }
    isInitialize = true;
  }

  Future<UserCredential?> signInWithGoogle() async {
    await _initSignIn();
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _authService
          .signInWithCredential(credential);
      return userCredential;

      // final user = UserModel.fromFirebaseUser(userCredential.user);
      // await UserDto.addUser(user);
      // return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([_authService.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  UserModel? getCurrentUser() {
    final user = _authService.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  Stream<UserModel?> authStateChanges() {
    return _authService.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
        return 'The credential is invalid or has expired.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this credential.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
