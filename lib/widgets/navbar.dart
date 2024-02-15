import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const NavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
          child: GNav(
            haptic: true,
            backgroundColor: Colors.black,
            gap: 8,
            activeColor: Colors.white,
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey.shade800,
            padding: const EdgeInsets.all(18),
            color: Colors.white,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.favorite_border,
                text: 'Favorites',
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
