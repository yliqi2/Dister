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
import 'package:dister/controller/provider/app_state_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => LoginAuthErrorNotifier()),
        ChangeNotifierProvider(create: (_) => RegisterErrorNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      appState.updateFromSystem();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.updateFromSystem();
    super.didChangePlatformBrightness();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null && locales.isNotEmpty) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      appState.updateFromSystem();
    }
    super.didChangeLocales(locales);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dister',
          theme: lightMode,
          darkTheme: netflix,
          themeMode: appState.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          navigatorKey: _navigatorKey,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: Locale(appState.languageCode),
          home: const Media(),
        );
      },
    );
  }
}
