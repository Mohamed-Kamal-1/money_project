import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/user_setting_repository.dart';

@Injectable(as: UserSettingRepository)
class UserSettingRepositoryImpl implements UserSettingRepository {
  final FirebaseFirestore _firestore;

  UserSettingRepositoryImpl(this._firestore);

  // ==================== User Settings ====================
  @override
  Stream<UserSettings?> getUserSettingsStream(String userId) {
    return _firestore.collection('user_settings').doc(userId).snapshots().map((
      doc,
    ) {
      if (!doc.exists) return null;
      final data = doc.data()!;
      return UserSettings(
        userId: userId,
        darkMode: data['darkMode'] as bool? ?? false,
        notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
        currency: data['currency'] as String,
      );
    });
  }

  @override
  Future<void> saveUserSettings(UserSettings settings) async {
    await _firestore.collection('user_settings').doc(settings.userId).set({
      'darkMode': settings.darkMode,
      'notificationsEnabled': settings.notificationsEnabled,
      'currency': settings.currency,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
