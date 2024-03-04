class LoginUserModel{
  String? email;
  String? password;

  LoginUserModel({required this.email, required this.password});

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      email: json['email'],
      password: json['password'],
    );
  }
  
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}