// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moviesearch/util/custom_snackbar.dart';
import '../config.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      try {
        var response = await http.post(
          Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);

          if (jsonResponse.containsKey('status')) {
            if (jsonResponse['status']) {
              // User registration successful
              showCustomSnackBar(context, 'Account created successfully!', Colors.green);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInPage(),
                ),
              );
            } else {
              // Registration failed
              showCustomSnackBar(
                  context, 'Registration failed. Try again.', Colors.red);
            }
          } else {
            print("Unexpected response format. 'status' key not found.");
          }
        } else {
          print('Error: ${response.statusCode}');
          // Handle non-200 status code appropriately
        }
      } catch (error) {
        print('Error sending HTTP request: $error');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/camera.png',
                    height: 80,
                  ),
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      errorStyle: const TextStyle(color: Colors.white),
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      errorStyle: const TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: registerUser,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 50)),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        },
                        child: const Text('Sign In',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
