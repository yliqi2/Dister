import 'package:dister/controller/provider/authnotifier.dart';
import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/pages/mobile/home/homescreen.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final boarding = prefs.getBool("onboarding") ?? false;
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthErrorNotifier(),
        ),
      ],
      child: MyApp(
        onboarding: boarding,
      )));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({
    super.key,
    this.onboarding = false,
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
      home: onboarding ? const Login() : const Onboarding(),
    );
  }
}
