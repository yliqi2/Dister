import 'package:dister/pages/mobile/onboarding/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:dister/controller/provider/authnotifier.dart';
import 'package:dister/controller/firebase/auth/logged.dart';
import 'package:dister/controller/shared_prefs/welcome.dart';
import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/pages/mobile/home/homescreen.dart';

import 'package:dister/pages/tablet/login.dart';

class Media extends StatelessWidget {
  const Media({super.key});

  @override
  Widget build(BuildContext context) {
    //screenWidth obtener el tamaño de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      //Codicional donde comparar la pantalla si es de mobil se mostrara la UI de mobil

      return FutureBuilder<User?>(
        future: Logged().checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const Homescreen();
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

      return LoginTab();
    }

    return const Placeholder();
  }
}
