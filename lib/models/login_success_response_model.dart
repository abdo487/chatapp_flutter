class LoginSuccessResponseModel {
  late String type;
  late String message;
  late Data data;

  LoginSuccessResponseModel(
      {required this.type, required this.message, required this.data});

  LoginSuccessResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['message'] = message;
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late String accessToken;
  late String refreshToken;
  late User user;

  Data(
      {required this.accessToken,
      required this.refreshToken,
      required this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['user'] = user.toJson();
    return data;
  }
}

class User {
  late String sId; // Changed from sId to sId
  late String email;
  late String username;
  late String image;
  late String bio;
  late bool isVerified;
  late String createdAt;
  late String updatedAt;

  User({
    required this.sId,
    required this.email,
    required this.username,
    required this.image,
    required this.bio,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    username = json['username'];
    image = json['image'];
    bio = json['bio'];
    isVerified = json['isVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['username'] = username;
    data['image'] = image;
    data['bio'] = bio;
    data['isVerified'] = isVerified;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
