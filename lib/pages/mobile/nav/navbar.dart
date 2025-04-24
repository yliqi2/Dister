import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:dister/pages/mobile/screens/new_post_screen.dart';
import 'package:dister/pages/mobile/screens/favorite_posts_screen.dart';
import 'package:dister/pages/mobile/screens/home_screen.dart';
import 'package:dister/pages/mobile/screens/profile_screen.dart';
import 'package:dister/pages/mobile/screens/api_posts_screen.dart';

import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Homescreen(),
    const APIposts(),
    const NewPostScreen(),
    const FavoritePostsScreen(),
    const Profile(),
  ];

  void selectePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).buttonTheme.colorScheme!.surface,
          border: const Border(
            top: BorderSide(
              color: Color.fromARGB(255, 107, 107, 107),
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: CrystalNavigationBar(
          splashColor: Colors.transparent,
          currentIndex: _selectedIndex,
          onTap: selectePage,
          backgroundColor: Theme.of(context).buttonTheme.colorScheme!.surface,
          enableFloatingNavBar: false,
          items: [
            CrystalNavigationBarItem(icon: Icons.home),
            CrystalNavigationBarItem(icon: Icons.travel_explore),
            CrystalNavigationBarItem(icon: Icons.add),
            CrystalNavigationBarItem(icon: Icons.favorite),
            CrystalNavigationBarItem(icon: Icons.person),
          ],
        ),
      ),
    );
  }
}
