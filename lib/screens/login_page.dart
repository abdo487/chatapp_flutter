import 'package:chatapp_flutter_1/models/login_model.dart';
import 'package:chatapp_flutter_1/models/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../outside_code/snippet_code_utils_modified/FormHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  LoginUserModel loginModel =
      LoginUserModel(email: "abdomouak@gmail.com", password: "123456");

  @override
  void initState() {
    super.initState();
  }

  String _email_error = "";
  String _password_error = "";

  bool isPasswordVisible = false;

  void onEmailError(String error) {
    setState(() {
      _email_error = error;
    });
  }

  void onPasswordError(String error) {
    setState(() {
      _password_error = error;
    });
  }

  Future<void> loginUser() async {
    const String apiUrl =
        'http:localhost:3000'; // Replace with your actual API endpoint

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'email': loginModel.email,
        'password': loginModel.password,
      },
    );

    if (response.statusCode == 200) {
      // Successful login
      final jsonResponse = json.decode(response.body);

      // Assuming your response model class is LoginResponseModel
      LoginResponseModel loginResponse = LoginResponseModel.fromJson(jsonResponse);

      if(loginResponse.type == "LOGIN_SUCCESS"){
        // Save user credentials to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', loginResponse.data);
        prefs.setString('userId', loginResponse.data['_id']);

        // USING GETx navigate to the home page

      }
      

      
    } else {
      // Handle error
      print('Login failed. Status code: ${response.statusCode}');
    }
  }

  // submitting

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
                        onEmailError("Email is Required");
                        return null;
                      }
                      onEmailError("");
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
                  _email_error != ""
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 5.0, bottom: 5.0),
                          child: Text(_email_error,
                              style: const TextStyle(color: Colors.red)),
                        )
                      : Container(padding: const EdgeInsets.all(5)),

                  // Password input field
                  FormHelper.inputFieldWidget(
                    context,
                    "Email",
                    "Enter your password",
                    (String value) {
                      if (value.isEmpty) {
                        onPasswordError("Password is Required");
                        return null;
                      }
                      onPasswordError("");
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
                      onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible),
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      color: Colors.grey,
                    ),
                    obscureText: !isPasswordVisible,
                    borderColor: Colors.grey,
                    borderFocusColor: const Color.fromARGB(255, 0, 120, 255),
                    borderRadius: 10,
                    hintColor: Colors.grey,
                    hintFontSize: 16,
                  ),
                  _password_error != ""
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 5.0),
                          child: Text(_password_error,
                              style: const TextStyle(color: Colors.red)),
                        )
                      : Container(),
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
