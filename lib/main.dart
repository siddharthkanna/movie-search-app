import 'package:flutter/material.dart';
import 'package:moviesearch/provider/movie_provider.dart';
import 'package:moviesearch/screens/home_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moviesearch/screens/login_page.dart';
import 'package:moviesearch/screens/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MyApp(token: prefs.getString('token')),
    ),
  );
}

class MyApp extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const MyApp({
    @required this.token,
    Key? key, 
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlickFind',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: (token != null && !JwtDecoder.isExpired(token))
          ? HomeScreen(
              token: token,
            )
          : const SignInPage(),
      routes: {
        '/login': (context) => const SignInPage(),
        'signup': (context) => const SignUpPage(),
        '/home': (context) => HomeScreen(
              token: token,
            ),
      },
    );
  }
}
