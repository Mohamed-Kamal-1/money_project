class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  UserModel({required this.uid, this.email, this.displayName, this.photoURL});

  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
    );
  }

  UserModel.fromMAp(Map<String, dynamic>? map)
    : this(
        uid: map?['uid'],
        email: map?['email'],
        displayName: map?['displayName'],
        photoURL: map?['photoURL'],
      );

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName)';
  }
}
