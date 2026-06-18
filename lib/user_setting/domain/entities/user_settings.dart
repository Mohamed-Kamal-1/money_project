import 'package:equatable/equatable.dart';

class UserSettings extends Equatable {
  final String userId;
  final bool darkMode;
  final bool notificationsEnabled;
  final String currency;

  const UserSettings({
    required this.userId,
    required this.darkMode,
    required this.notificationsEnabled,
    required this.currency,
  });

  @override
  List<Object?> get props => [userId, darkMode, notificationsEnabled, currency];

  UserSettings copyWith({
    String? userId,
    bool? darkMode,
    bool? notificationsEnabled,
    String? currency,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      currency: currency ?? this.currency,
    );
  }
}
