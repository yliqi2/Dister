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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dister/controller/blocs/app_state_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cargar preferencias para inicializar el bloc
  final prefs = await SharedPreferences.getInstance();

  // Verificar si queremos usar el tema del sistema
  final useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
  final useSystemLanguage = prefs.getBool('useSystemLanguage') ?? true;

  // Obtener el tema e idioma actuales del sistema
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  final isDarkTheme = useSystemTheme
      ? brightness == Brightness.dark
      : prefs.getBool('isDarkTheme') ?? false;

  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final languageCode = useSystemLanguage
      ? systemLocale.languageCode
      : prefs.getString('languageCode') ?? 'en';

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => AppStateBloc()
            ..add(ThemeChanged(isDarkTheme))
            ..add(LanguageChanged(languageCode))
            ..add(UseSystemTheme(useSystemTheme))
            ..add(UseSystemLanguage(useSystemLanguage)),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginAuthErrorNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterErrorNotifier(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // Clave global para mantener el estado de navegación
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Actualizar con el tema y el idioma del sistema al inicio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appStateBloc = BlocProvider.of<AppStateBloc>(context);
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      appStateBloc.add(UpdateFromSystem(brightness, locale));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Cuando cambia el tema del sistema
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    BlocProvider.of<AppStateBloc>(context)
        .add(UpdateFromSystem(brightness, locale));
    super.didChangePlatformBrightness();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // Cuando cambia el idioma del sistema
    if (locales != null && locales.isNotEmpty) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      BlocProvider.of<AppStateBloc>(context)
          .add(UpdateFromSystem(brightness, locales.first));
    }
    super.didChangeLocales(locales);
  }

  @override
  Widget build(BuildContext context) {
    // Usar el AppStateBloc para manejar el estado de la app
    return BlocBuilder<AppStateBloc, AppState>(
      builder: (context, appState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dister',
          theme: lightMode,
          darkTheme: netflix,
          themeMode: appState.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          navigatorKey:
              _navigatorKey, // Usar la clave global para mantener el estado de navegación
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
