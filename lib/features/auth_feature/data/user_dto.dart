class UserDto {
  String? name;
  String? email;
  String? password;
  String? confirmPassword;
  double? balance;
  double? income;
  double? expenses;

  UserDto({this.name, this.email, this.password, this.confirmPassword});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'balance': balance,
      'income': income,
      'expenses': expenses,
    };
  }
}
