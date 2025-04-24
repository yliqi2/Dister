import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:dister/pages/mobile/Posts%20Upload/new_post.dart';
import 'package:dister/pages/mobile/Favorite%20Posts/favorite_posts.dart';
import 'package:dister/pages/mobile/home/homescreen.dart';
import 'package:dister/pages/mobile/profile/profile.dart';
import 'package:dister/pages/mobile/API%20posts/api_posts.dart';

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
    const Realtime(),
    const NewPost(),
    const FavoritePosts(),
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
