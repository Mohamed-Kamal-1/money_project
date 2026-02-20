import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money/features/auth_feature/data/user_dto.dart';

class AppFirebaseAuth {
  var firebaseUser = FirebaseAuth.instance;
  var database = FirebaseFirestore.instance;
  late UserAuthDto user;

  Future<void> register(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    user = UserAuthDto(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    );
    database.collection('users').add(user.toJson());
  }
}

class AuthResponse {
  bool success;
  String? message;

  AuthResponse({required this.success, this.message});
}

// enum AuthFaiture{
//
// }
