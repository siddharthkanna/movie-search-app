import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moviesearch/pages/favorite_page.dart';
import 'package:moviesearch/pages/home_page.dart';
import 'package:moviesearch/pages/search_page.dart';
import 'package:moviesearch/util/custom_snackbar.dart';
import 'package:moviesearch/widgets/navbar.dart';
import 'package:moviesearch/widgets/sort_dropdown.dart';

class HomeScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;

  const HomeScreen({
    Key? key,
    this.token,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userId;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
  }

  void _handleLogout() {
    Navigator.pushReplacementNamed(context, '/login');
    showCustomSnackBar(context, 'Logged out successfully!', Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(
              'assets/images/letterboxd-logo.png',
              height: 30,
            ),
            const SizedBox(width: 8.0),
            const Text(
              'FlickFind',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          const SortDropdown(),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: const [
          HomePage(),
          SearchPage(),
          FavoritePage(),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          });
        },
      ),
    );
  }
}
