import 'package:chatapp_flutter_1/controllers/auth_controller.dart';
import 'package:chatapp_flutter_1/controllers/login_controller.dart';
import 'package:get/get.dart';

class InitDep extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => AuthController());
  }
}
