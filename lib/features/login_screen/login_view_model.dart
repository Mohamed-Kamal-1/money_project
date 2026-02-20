import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'login_state.dart';


class LoginViewModel extends Cubit<LoginState> {
  // final AuthRepo _loginAuthRepo;

  LoginViewModel() : super(LoginInitialState());

  // Future<void> login(String email, String password) async {
  //   // String? avater = await AuthSharedPreferences.getAvatar();
  //   emit(LoginLoadingState());
  //   final response = await _loginAuthRepo.login(email, password);
  //   switch (response) {
  //     case Success():
  //       {
  //         if (response.data.token != null) {
  //           if (response.data.user?.name != null &&
  //               response.data.user?.email != null) {
  //               emit(LoginSuccessState());
  //
  //             // UserInfo().setUser(
  //             //     response.data.user!.name, response.data.user!.email);
  //             // await Future.wait([
  //             //   AuthSharedPreferences.saveToken(response.data.token!),
  //             //   AuthSharedPreferences.saveName(response.data.user?.name),
  //             //   AuthSharedPreferences.saveAvatar(avater ?? AppImage.avatar_1),
  //             // ]);
  //           }
  //         }
  //               // emit(LoginSuccessState());
  //       }
  //
  //     case Failure():
  //       emit(LoginErrorState(errorMessage: response.exception));
  //   }
  // }

  // Future<void> loginWithGoogle() async {
  //   try {
  //     emit(LoginLoadingState());
  //
  //     // TODO: Implement Google login logic here
  //     // For now, just show error that it's not implemented
  //     emit(LoginErrorState(
  //       errorMessage: 'Google login is not yet implemented',
  //     ));
  //   } catch (e) {
  //     emit(LoginErrorState(errorMessage: e.toString()));
  //   }
  // }
}
