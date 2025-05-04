import 'package:dister/widgets/navigation_bar.dart';
import 'package:dister/screens/mobile/others/intro_pages_screen.dart';
import 'package:dister/screens/mobile/others/login_screen.dart';

import 'package:dister/screens/tablet/others/login_tablet_screen.dart';

import 'package:dister/controllers/firebase/auth/logged.dart';
import 'package:dister/controllers/shared_prefs/welcome.dart';
import 'package:dister/screens/tablet/others/home_tablet_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Media extends StatefulWidget {
  const Media({super.key});

  @override
  State<Media> createState() => _MediaState();
}

class _MediaState extends State<Media> {
  User? _user;
  bool _isLoading = true;
  bool _seenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final user = await Logged().checkUserLoggedIn();
    final seenOnboarding = await Welcome().seenBoarding();

    if (!mounted) return;

    setState(() {
      _user = user;
      _seenOnboarding = seenOnboarding;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    if (isTablet) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!isTablet) {
      if (_user != null) {
        return const Navbar();
      } else {
        return _seenOnboarding ? const LoginScreen() : const IntroPagesScreen();
      }
    } else {
      if (_user != null) {
        return const HomeTabletScreen();
      } else {
        return const LoginTabletScreen();
      }
    }
  }
}
