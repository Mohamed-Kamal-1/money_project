import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_settings.dart';
import '../../../domain/repositories/user_setting_repository.dart';
import 'user_settings_state.dart';

@injectable
class UserSettingsCubit extends Cubit<UserSettingsState> {
  final UserSettingRepository _repository;
  StreamSubscription<UserSettings?>? _settingsSubscription;

  UserSettingsCubit(this._repository) : super(UserSettingsInitial());

  void listenToSettings(String userId) {
    emit(UserSettingsLoading());
    _settingsSubscription?.cancel();
    _settingsSubscription = _repository.getUserSettingsStream(userId).listen((
      settings,
    ) {
      if (settings != null) {
        emit(UserSettingsLoaded(settings));
      } else {
        // إذا لم تكن الإعدادات موجودة، ننشئ إعدادات افتراضية
        final defaultSettings = UserSettings(
          userId: userId,
          darkMode: true,
          notificationsEnabled: true,
          currency: 'USD',
        );
        emit(UserSettingsLoaded(defaultSettings));
      }
    }, onError: (error) => emit(UserSettingsError(error.toString())));
  }

  Future<void> toggleDarkMode(String userId, bool value) async {
    final currentState = state;
    if (currentState is UserSettingsLoaded) {
      final newSettings = currentState.settings.copyWith(darkMode: value);
      await _repository.saveUserSettings(newSettings);
      // سيتم تحديث الـ state تلقائياً عبر الـ stream
    }
  }

  Future<void> toggleNotifications(String userId, bool value) async {
    final currentState = state;
    if (currentState is UserSettingsLoaded) {
      final newSettings = currentState.settings.copyWith(
        notificationsEnabled: value,
      );
      await _repository.saveUserSettings(newSettings);
    }
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}
