import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? emailVerifiedAt;

  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerifiedAt,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    emailVerifiedAt,
  ];

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? emailVerifiedAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    );
  }
}
