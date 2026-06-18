import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'result.dart';

Future<Result<T>> executeFirebase<T>(Future<T> Function() firebaseCall) async {
  try {
    final response = await firebaseCall();
    return Success(response);
  } on FirebaseAuthException catch (e) {
    return Failure(Exception(e.message ?? 'Authentication Error'));
  } on FirebaseException catch (e) {
    return Failure(Exception(e.message ?? 'Database Error'));
  } on TimeoutException {
    return Failure(Exception('Connection Timeout - Check your internet'));
  } catch (e) {
    return Failure(Exception('Something went wrong: ${e.toString()}'));
  }
}
