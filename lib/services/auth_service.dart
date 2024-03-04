import 'package:chatapp_flutter_1/controllers/login_controller.dart';
import 'package:chatapp_flutter_1/models/login_success_response_model.dart';
import 'package:chatapp_flutter_1/screens/home_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loginUser(String email, String password) async {
  const String apiUrl = 'http://192.168.122.82:3000/api/auth/login';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // this controller handles the error state of the email or password
    LoginController controller = Get.find();

    final jsonResponse = json.decode(response.body);
    if (jsonResponse['type'] == "EMAIL_ERR") {
      controller.onEmailError(jsonResponse['message']);
      return;
    } else if (jsonResponse['type'] == "PASSWORD_ERR") {
      controller.onPasswordError(jsonResponse['message']);
      return;
    }

    LoginSuccessResponseModel loginResponse =
        LoginSuccessResponseModel.fromJson(jsonResponse);
    if (loginResponse.type == "LOGIN_SUCCESS") {
      Data data = loginResponse.data;
      User user = data.user;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data.accessToken);
      prefs.setString('user', json.encode(user));

      Get.to(const HomePage(), transition: Transition.fade);
    }
  } else {
    // Handle error
  }
}
