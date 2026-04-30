import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// حالة خاصة لو عايز تتأكد من الـ Login Status أول ما الأبلكيشن يفتح
class Authenticated extends AuthState {}
class Unauthenticated extends AuthState {}