import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 1. تأكد إن الكلاس ده فيه success ويكون مطلوب (required)
class AuthResponse {
  final bool success;
  final String? message;
  final User? user;

  AuthResponse({required this.success, this.message, this.user});
}

// 2. الـ Provider لازم يورث من ChangeNotifier عشان الـ UI يشتغل
class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  AppAuthProvider() {
    // مراقبة حالة المستخدم
    _firebaseAuth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  // 3. دالة الـ login (عدلت الـ Return عشان يوافق الـ AuthResponse الجديد)
  Future<AuthResponse> login(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // هنا بنبعت success: true
      return AuthResponse(success: true, user: result.user, message: "تم تسجيل الدخول بنجاح");
    } catch (e) {
      // هنا بنبعت success: false
      return AuthResponse(success: false, user: null, message: e.toString());
    }
  }

  // 4. دالة الـ register
  Future<AuthResponse> register(String email, String password, String name, String phoneNumber) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // هنا ممكن تضيف كود Firestore لاحقاً
      return AuthResponse(success: true, user: result.user, message: "تم إنشاء الحساب بنجاح");
    } catch (e) {
      return AuthResponse(success: false, user: null, message: e.toString());
    }
  }

  // 5. دالة الـ signOut
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
