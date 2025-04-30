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
  bool? _isTablet; // Almacena el tipo de dispositivo

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final user = await Logged().checkUserLoggedIn();
    final seenOnboarding = await Welcome().seenBoarding();

    if (!mounted) return;

    // Detectar el tipo de dispositivo una sola vez
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final devicePixelRatio = mediaQuery.devicePixelRatio;

    // Calcular el tamaño físico real en pulgadas
    final physicalWidth = size.width * devicePixelRatio;
    final physicalHeight = size.height * devicePixelRatio;
    final diagonalInches =
        (physicalWidth * physicalWidth + physicalHeight * physicalHeight) /
            (devicePixelRatio * devicePixelRatio * 160 * 160);

    // Criterios para detectar tablet en Android
    final isLargeScreen = diagonalInches > 7.0;
    final hasTabletDensity = (size.width / devicePixelRatio) >= 600;
    final hasTabletAspectRatio = size.longestSide / size.shortestSide <= 1.6;

    final isTablet = isLargeScreen && hasTabletDensity && hasTabletAspectRatio;

    // Establecer la orientación según el tipo de dispositivo
    if (isTablet) {
      // Forzar orientación horizontal para tablets
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Forzar orientación vertical para móviles
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    setState(() {
      _user = user;
      _seenOnboarding = seenOnboarding;
      _isTablet = isTablet;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isTablet == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isTablet!) {
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
