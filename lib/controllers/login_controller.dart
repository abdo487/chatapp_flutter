import 'package:get/get.dart';

class LoginController extends GetxController {
  String _emailError = "";
  String _passwordError = "";
  bool _isPasswordVisible = false;

  get emailError => _emailError;
  get passwordError => _passwordError;
  get isPasswordVisible => _isPasswordVisible;

  void onEmailError(String error) {
    _emailError = error;
    update();
  }

  void onPasswordError(String error) {
    _passwordError = error;
    update();
  }

  void switchPasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    update();
  }
}
