// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:moviesearch/screens/home_page.dart';
import 'package:moviesearch/screens/signup_page.dart';
import 'package:moviesearch/util/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      try {
        var response = await http.post(
          Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody),
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);

          if (jsonResponse.containsKey('status')) {
            if (jsonResponse['status']) {
              // User login successful
              var myToken = jsonResponse['token'];
              prefs.setString('token', myToken);

              showCustomSnackBar(context, 'Logged in successfully!',
                  const Color.fromARGB(255, 36, 152, 247));

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(token: myToken),
                ),
              );
            } else {
              // Login failed
              showCustomSnackBar(
                  context, 'Invalid email or password', Colors.red);
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

      // Show snackbar for validation error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter proper information'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/letterboxd-logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      errorText: _isNotValidate ? 'Enter proper info' : null,
                      errorStyle: const TextStyle(color: Colors.red),
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      errorText: _isNotValidate
                          ? 'Please enter valid information'
                          : null,
                      errorStyle: const TextStyle(color: Colors.red),
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loginUser,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 50)),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text('Sign Up',
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
