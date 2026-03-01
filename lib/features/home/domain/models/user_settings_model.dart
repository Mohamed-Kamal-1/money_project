import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettings {
  final String userId;
  final bool darkMode;
  final bool notificationsEnabled;
  final String currency;
  final double balance;
  final double? monthlyBudget;
  final DateTime updatedAt;

  UserSettings({
    required this.userId,
    this.darkMode = true,
    this.notificationsEnabled = false,
    this.currency = 'USD',
    this.balance = 0.0,
    this.monthlyBudget,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'darkMode': darkMode,
      'notificationsEnabled': notificationsEnabled,
      'currency': currency,
      'balance': balance,
      'monthlyBudget': monthlyBudget,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory UserSettings.fromJson(Map<String, dynamic> json, String userId) {
    return UserSettings(
      userId: userId,
      darkMode: json['darkMode'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
      currency: json['currency'] as String? ?? 'USD',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      monthlyBudget: (json['monthlyBudget'] as num?)?.toDouble(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create from DocumentSnapshot
  factory UserSettings.fromFirestore(DocumentSnapshot doc, String userId) {
    return UserSettings.fromJson(doc.data() as Map<String, dynamic>, userId);
  }

  // Copy with method
  UserSettings copyWith({
    String? userId,
    bool? darkMode,
    bool? notificationsEnabled,
    String? currency,
    double? balance,
    double? monthlyBudget,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
