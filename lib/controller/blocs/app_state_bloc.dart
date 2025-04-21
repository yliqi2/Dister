import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Eventos del AppState
abstract class AppStateEvent {}

class ThemeChanged extends AppStateEvent {
  final bool isDarkTheme;
  ThemeChanged(this.isDarkTheme);
}

class LanguageChanged extends AppStateEvent {
  final String languageCode;
  LanguageChanged(this.languageCode);
}

class UseSystemTheme extends AppStateEvent {
  final bool useSystemTheme;
  UseSystemTheme(this.useSystemTheme);
}

class UseSystemLanguage extends AppStateEvent {
  final bool useSystemLanguage;
  UseSystemLanguage(this.useSystemLanguage);
}

class UpdateFromSystem extends AppStateEvent {
  final Brightness systemBrightness;
  final Locale systemLocale;

  UpdateFromSystem(this.systemBrightness, this.systemLocale);
}

class InitializeState extends AppStateEvent {
  final AppState initialState;
  InitializeState({required this.initialState});
}

// Estado del AppState
class AppState {
  final bool isDarkTheme;
  final String languageCode;
  final bool useSystemTheme;
  final bool useSystemLanguage;

  AppState({
    required this.isDarkTheme,
    required this.languageCode,
    this.useSystemTheme = true,
    this.useSystemLanguage = true,
  });

  AppState copyWith({
    bool? isDarkTheme,
    String? languageCode,
    bool? useSystemTheme,
    bool? useSystemLanguage,
  }) {
    return AppState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      languageCode: languageCode ?? this.languageCode,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      useSystemLanguage: useSystemLanguage ?? this.useSystemLanguage,
    );
  }

  // Guardar estado en SharedPreferences
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
    await prefs.setString('languageCode', languageCode);
    await prefs.setBool('useSystemTheme', useSystemTheme);
    await prefs.setBool('useSystemLanguage', useSystemLanguage);
  }

  // Cargar estado desde SharedPreferences
  static Future<AppState> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
    final useSystemLanguage = prefs.getBool('useSystemLanguage') ?? true;

    // Obtener el tema del sistema
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final systemIsDark = brightness == Brightness.dark;

    // Decidir qué tema usar
    final isDarkTheme =
        useSystemTheme ? systemIsDark : (prefs.getBool('isDarkTheme') ?? false);

    // Obtener el idioma del sistema
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final languageCode = useSystemLanguage
        ? systemLocale.languageCode
        : (prefs.getString('languageCode') ?? 'en');

    return AppState(
      isDarkTheme: isDarkTheme,
      languageCode: languageCode,
      useSystemTheme: useSystemTheme,
      useSystemLanguage: useSystemLanguage,
    );
  }
}

// BLoC para AppState
class AppStateBloc extends Bloc<AppStateEvent, AppState> {
  AppStateBloc()
      : super(AppState(
            isDarkTheme:
                WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.dark,
            languageCode:
                WidgetsBinding.instance.platformDispatcher.locale.languageCode,
            useSystemTheme: true,
            useSystemLanguage: true)) {
    // Inicializar desde SharedPreferences
    _loadInitialState();

    on<ThemeChanged>((event, emit) {
      final newState = state.copyWith(isDarkTheme: event.isDarkTheme);
      emit(newState);
      newState.saveToPrefs();
    });

    on<LanguageChanged>((event, emit) {
      final newState = state.copyWith(languageCode: event.languageCode);
      emit(newState);
      newState.saveToPrefs();
    });

    on<UseSystemTheme>((event, emit) {
      final newState = state.copyWith(useSystemTheme: event.useSystemTheme);
      emit(newState);
      newState.saveToPrefs();

      if (event.useSystemTheme) {
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        final isDarkMode = brightness == Brightness.dark;
        final updatedState = state.copyWith(isDarkTheme: isDarkMode);
        emit(updatedState);
        updatedState.saveToPrefs();
      }
    });

    on<UseSystemLanguage>((event, emit) {
      final newState =
          state.copyWith(useSystemLanguage: event.useSystemLanguage);
      emit(newState);
      newState.saveToPrefs();

      if (event.useSystemLanguage) {
        final locale = WidgetsBinding.instance.platformDispatcher.locale;
        final updatedState = state.copyWith(languageCode: locale.languageCode);
        emit(updatedState);
        updatedState.saveToPrefs();
      }
    });

    on<UpdateFromSystem>((event, emit) {
      bool isDarkMode = event.systemBrightness == Brightness.dark;
      String languageCode = event.systemLocale.languageCode;

      // Aplicar cambios según la configuración
      bool updateTheme =
          state.useSystemTheme && (state.isDarkTheme != isDarkMode);
      bool updateLanguage =
          state.useSystemLanguage && (state.languageCode != languageCode);

      if (updateTheme || updateLanguage) {
        final newState = state.copyWith(
          isDarkTheme: updateTheme ? isDarkMode : state.isDarkTheme,
          languageCode: updateLanguage ? languageCode : state.languageCode,
        );

        emit(newState);
        newState.saveToPrefs();
      }
    });

    on<InitializeState>((event, emit) async {
      emit(event.initialState);
    });
  }

  void _loadInitialState() async {
    final initialState = await AppState.loadFromPrefs();
    add(InitializeState(initialState: initialState));
  }
}
