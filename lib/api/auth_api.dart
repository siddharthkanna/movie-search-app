import 'dart:convert';
import 'package:dio/dio.dart';
import '../config.dart';

class AuthApi {
  static final Dio _dio = Dio();

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    var reqBody = {"email": email, "password": password};

    try {
      var response = await _dio.post(
        login,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: jsonEncode(reqBody),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error sending HTTP request: $error');
    }
  }

  static Future<Map<String, dynamic>> registerUser(
      String email, String password) async {
    var reqBody = {"email": email, "password": password};

    try {
      var response = await _dio.post(
        registration,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: jsonEncode(reqBody),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error sending HTTP request: $error');
    }
  }
}
