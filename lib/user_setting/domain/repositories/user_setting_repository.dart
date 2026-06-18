import 'dart:async';

import '../entities/user_settings.dart';

abstract interface class UserSettingRepository {
  // ==================== User Settings ====================
  Stream<UserSettings?> getUserSettingsStream(String userId);

  Future<void> saveUserSettings(UserSettings settings);
}
