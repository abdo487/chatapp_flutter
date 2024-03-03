class LoginResponseModel {
  String? type;
  String? message;
  Map<String, dynamic>? data;

  LoginResponseModel({this.type, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {
      'type': type,
      'message': message,
    };

    if (data != null) {
      jsonData['data'] = data;
    }

    return jsonData;
  }
}
