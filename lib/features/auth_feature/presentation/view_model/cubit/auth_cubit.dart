// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../core/errors/result.dart';
//
// import '../../../domain/auth_repo.dart';
//
// import 'auth_state.dart';
//
// class AuthCubit extends Cubit<AuthState> {
//   final AuthRepository _authRepository;
//
//   AuthCubit(this._authRepository) : super(AuthInitial());
//
//   Future<void> login(String email, String password) async {
//     emit(AuthLoading());
//     final result = await _authRepository.login(email: email, password: password);
//
//     if (result is Success) {
//       emit(AuthSuccess());
//     } else if (result is Failure) {
//       emit(AuthError(result.exception.toString()));
//     }
//   }
//
//   Future<void> register(String email, String password) async {
//     emit(AuthLoading());
//     final result = await _authRepository.register(email: email, password: password);
//
//     if (result is Success) {
//       emit(AuthSuccess());
//     } else if (result is Failure) {
//       emit(AuthError(result.exception.toString()));
//     }
//   }
// }
