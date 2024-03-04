import 'package:chatapp_flutter_1/controllers/auth_controller.dart';
import 'package:chatapp_flutter_1/helpers/bindings.dart';
import 'package:chatapp_flutter_1/screens/home_page.dart';
import 'package:chatapp_flutter_1/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(initialBinding: InitDep(), home: const App());
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkAuth(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshots.hasError) {
              return const Scaffold(
                body: Center(child: Text("Error")),
              );
            } else {
              return snapshots.data == null
                  ? const LoginPage()
                  : const HomePage();
            }
          }
        });
  }

  Future<String?> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token != null) {
      return token ?? "";
    }
    return null;
  }
}
