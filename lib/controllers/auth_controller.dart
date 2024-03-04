import 'package:chatapp_flutter_1/models/login_success_response_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  bool _isAuth = false;
  User? _user;

  get isAuth => _isAuth;
  get user => _user;

  void switchAuth(bool auth) {
    _isAuth = auth;
  }

  void setUser(User user) {
    _user = user;
  }
}
