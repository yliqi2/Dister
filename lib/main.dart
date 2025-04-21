import 'package:dister/controller/provider/authnotifier.dart';
import 'package:flutter/material.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:dister/theme/light_mode.dart';
import 'package:dister/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dister/controller/firebase/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:dister/controller/media/media.dart';
import 'package:dister/controller/provider/theme_notifier.dart'; // Import ThemeNotifier
import 'package:dister/controller/provider/language_notifier.dart'; // Import LanguageNotifier

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
          create: (context) => LoginAuthErrorNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterErrorNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeNotifier(), // Add ThemeNotifier provider
        ),
        ChangeNotifierProvider(
          create: (context) =>
              LanguageNotifier(), // Add LanguageNotifier provider
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
    final themeNotifier =
        Provider.of<ThemeNotifier>(context); // Access ThemeNotifier

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dister',
      theme: lightMode,
      darkTheme: netflix,
      themeMode: themeNotifier.isDarkTheme
          ? ThemeMode.dark
          : ThemeMode.light, // Use theme mode
      navigatorKey: GlobalKey<NavigatorState>(), // Add navigatorKey
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const Media(),
    );
  }
}
