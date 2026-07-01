import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'result.dart';

/// Function to handle Firebase calls safely and return a [Result]
Future<Result<T>> executeFirebase<T>(Future<T> Function() firebaseCall) async {
  try {
    final response = await firebaseCall();
    return Success(response);
  } on FirebaseAuthException catch (e) {
    // Handling Auth specific errors (Wrong password, user not found, etc.)
    return Failure(Exception(e.message ?? 'Authentication Error'));
  } on FirebaseException catch (e) {
    // Handling Firestore specific errors (Permission denied, Timeout, etc.)
    return Failure(Exception(e.message ?? 'Database Error'));
  } on TimeoutException {
    return Failure(Exception('Connection Timeout - Check your internet'));
  } catch (e) {
    // Handling any other unexpected errors
    return Failure(Exception('Something went wrong: ${e.toString()}'));
  }
}
