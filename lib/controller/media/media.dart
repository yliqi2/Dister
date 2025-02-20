import 'package:dister/pages/mobile/nav/navbar.dart';
import 'package:dister/pages/mobile/onboarding/onboarding.dart';
import 'package:dister/pages/mobile/auth/login.dart';

import 'package:dister/pages/tablet/auth/logintablet.dart';

import 'package:dister/controller/firebase/auth/logged.dart';
import 'package:dister/controller/shared_prefs/welcome.dart';
import 'package:dister/pages/tablet/home/homeTablet.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Media extends StatelessWidget {
  const Media({super.key});

  @override
  Widget build(BuildContext context) {
    //screenWidth obtener el tamaño de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      //Codicional donde comparar la pantalla si es de movil se mostrara la UI de movil

      return FutureBuilder<User?>(
        future: Logged().checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const Navbar();
          } else {
            return FutureBuilder<bool>(
              future: Welcome().seenBoarding(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final seenOnboarding = snapshot.data ?? false;
                  return seenOnboarding ? const Login() : const Onboarding();
                }
              },
            );
          }
        },
      );
    } else {
      //En caso contrario la UI de Tablet

      return FutureBuilder<User?>(
        future: Logged().checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomeTablet();
          } else {
            return const LoginTab();
          }
        },
      );
    }
  }
}
