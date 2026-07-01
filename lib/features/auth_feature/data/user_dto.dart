class UserAuthDto {
  String? name;
  String? email;
  String? password;

  String? rePassword;

  String? phoneNumber;

  UserAuthDto(
      {this.name, this.email, this.password, this.rePassword, this.phoneNumber});

  factory UserAuthDto.fromFirebaseUser(dynamic firebaseUser) {
    if (firebaseUser == null) {
      return UserAuthDto();
    }

    return UserAuthDto(
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'rePassword': rePassword,
      'phoneNumber': phoneNumber,

    };
  }

  UserAuthDto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }
}
