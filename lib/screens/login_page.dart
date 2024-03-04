import 'package:chatapp_flutter_1/controllers/login_controller.dart';
import 'package:chatapp_flutter_1/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chatapp_flutter_1/outside_code/snippet_code_utils_modified/FormHelper.dart';
import 'package:chatapp_flutter_1/services/auth_service.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  LoginUserModel loginModel =
      LoginUserModel(email: "abdomouak@gmail.com", password: "123456");
  LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // this page will have a form with two fields: email and password
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return _uiWidget();
  }

  Widget _uiWidget() {
    return Scaffold(
      body: Form(
          key: globalKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: [
                  logoWidget(),
                  FormHelper.inputFieldWidget(
                    context,
                    "Email",
                    "Enter your email",
                    (String value) {
                      if (value.isEmpty) {
                        controller.onEmailError("Email is Required");
                        return null;
                      }
                      controller.onEmailError("");
                    },
                    (String value) {
                      loginModel.email = value;
                    },
                    initialValue: loginModel.email ?? "",
                    prefixIcon: const Icon(Icons.email),
                    showPrefixIcon: true,
                    prefixIconPaddingLeft: 10,
                    prefixIconColor: Colors.grey,
                    borderColor: Colors.grey,
                    borderFocusColor: const Color.fromARGB(255, 0, 120, 255),
                    borderRadius: 10,
                    hintColor: Colors.grey,
                    hintFontSize: 16,
                  ),
                  // these next widget depends on some getx state
                  GetBuilder<LoginController>(builder: (tap){
                    return Column(
                      children: [
                        controller.emailError != ""
                          ? Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 5.0, bottom: 5.0),
                              child: Text(controller.emailError,
                                  style: const TextStyle(color: Colors.red)),
                            )
                          : Container(padding: const EdgeInsets.all(5)),
                        FormHelper.inputFieldWidget(
                          context,
                          "Password",
                          "Enter your password",
                          (String value) {
                            if (value.isEmpty) {
                              controller.onPasswordError("Password is Required");
                              return null;
                            }
                            controller.onPasswordError("");
                          },
                          (String value) {
                            loginModel.password = value;
                          },
                          initialValue: loginModel.password ?? "",
                          prefixIcon: const Icon(Icons.lock),
                          showPrefixIcon: true,
                          prefixIconPaddingLeft: 10,
                          prefixIconColor: Colors.grey,
                          suffixIcon: IconButton(
                            onPressed: controller.switchPasswordVisibility,
                            icon: Icon(
                                    controller.isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility
                                  ),
                            color: Colors.grey,
                          ),
                          obscureText: !controller.isPasswordVisible,
                          borderColor: Colors.grey,
                          borderFocusColor: const Color.fromARGB(255, 0, 120, 255),
                          borderRadius: 10,
                          hintColor: Colors.grey,
                          hintFontSize: 16,
                        ),
                        controller.passwordError != ""
                            ? Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 5.0),
                                child: Text(controller.passwordError,
                                    style: const TextStyle(color: Colors.red)),
                              )
                            : Container()
                      ],
                    );
                  }),
                  // forgot password
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 120, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Submit button
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: FormHelper.submitButton('Login', () {
                      if (globalKey.currentState!.validate()) {
                        globalKey.currentState!.save();
                        String email = loginModel.email ?? "";
                        String password = loginModel.password ?? "";

                        loginUser(email, password);
                      }
                    },
                        btnColor: const Color.fromARGB(255, 0, 120, 255),
                        borderColor: const Color.fromARGB(255, 0, 120, 255),
                        txtColor: Colors.white,
                        width: double.infinity,
                        borderRadius: 10),
                  ),
                  // Or
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 50.0, right: 50.0),
                      child: Stack(
                        // make the stack appear in the top of it parent
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1.0),
                              color: Colors.grey,
                            ),
                          ),
                          Positioned(
                            top: -20.0,
                            left: MediaQuery.of(context).size.width / 2 - 80.0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  // Sign up
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 120, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget logoWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 150, bottom: 50),
      child: Container(
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Image(
                width: 150.0,
                image: AssetImage('assets/icons/logo.png'),
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: Text(
                "UsBoth",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text("Fill you information",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }
}
