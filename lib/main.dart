import 'package:dister/controller/provider/authnotifier.dart';
import 'package:dister/controller/firebase/auth/logged.dart';
import 'package:dister/controller/shared_prefs/welcome.dart';
import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/pages/mobile/home/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:dister/theme/dark_mode.dart';
import 'package:dister/theme/light_mode.dart';
import 'package:dister/pages/mobile/onboarding/onboarding.dart';
import 'package:dister/generated/l10n.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:dister/controller/firebase/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthErrorNotifier(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dister',
      theme: lightMode,
      darkTheme: netflix,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: FutureBuilder<User?>(
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
      ),
    );
  }
}
