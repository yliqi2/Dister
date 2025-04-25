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

    if (mounted) {
      setState(() {
        _user = user;
        _seenOnboarding = seenOnboarding;
        _isLoading = false;
      });
    }
  }

  bool _isTablet(BuildContext context) {
    // Obtener información de la pantalla
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size size = mediaQuery.size;
    final double devicePixelRatio = mediaQuery.devicePixelRatio;

    // Calcular el tamaño físico real en pulgadas
    final double physicalWidth = size.width * devicePixelRatio;
    final double physicalHeight = size.height * devicePixelRatio;
    final double diagonalInches =
        (physicalWidth * physicalWidth + physicalHeight * physicalHeight) /
            (devicePixelRatio * devicePixelRatio * 160 * 160);

    // En Android, una tablet típicamente tiene:
    // - Diagonal mayor a 7 pulgadas
    // - Densidad de píxeles menor a 600dp
    // - Ratio de aspecto menor a 1.6 para excluir teléfonos muy alargados
    bool isLargeScreen = diagonalInches > 7.0;
    bool hasTabletDensity = (size.width / devicePixelRatio) >= 600;
    bool hasTabletAspectRatio = size.longestSide / size.shortestSide <= 1.6;

    return isLargeScreen && hasTabletDensity && hasTabletAspectRatio;
  }

  void _setOrientation(bool isTablet) {
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
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = _isTablet(context);

    // Establecer la orientación según el tipo de dispositivo
    _setOrientation(isTablet);

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

  @override
  void dispose() {
    // Restaurar todas las orientaciones cuando se destruye el widget
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
}
