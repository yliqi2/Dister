import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dister/generated/l10n.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isDarkTheme = false;
  String _languageCode = 'en';
  bool _useSystemTheme = true;
  bool _useSystemLanguage = true;
  bool _saveCredentials = false;
  String? _savedEmail;
  String? _savedPassword;

  AppStateProvider() {
    _loadInitialState();
  }

  bool get isDarkTheme => _isDarkTheme;
  String get languageCode => _languageCode;
  bool get useSystemTheme => _useSystemTheme;
  bool get useSystemLanguage => _useSystemLanguage;
  bool get saveCredentials => _saveCredentials;
  String? get savedEmail => _savedEmail;
  String? get savedPassword => _savedPassword;

  Future<void> _loadInitialState() async {
    final prefs = await SharedPreferences.getInstance();

    _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
    _useSystemLanguage = prefs.getBool('useSystemLanguage') ?? true;
    _saveCredentials = prefs.getBool('saveCredentials') ?? false;

    _savedEmail = prefs.getString('savedEmail');
    _savedPassword = prefs.getString('savedPassword');

    // Obtener el tema del sistema
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final systemIsDark = brightness == Brightness.dark;

    _isDarkTheme = _useSystemTheme
        ? systemIsDark
        : (prefs.getBool('isDarkTheme') ?? false);

    // Obtener el idioma del sistema
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    _languageCode = _useSystemLanguage
        ? systemLocale.languageCode
        : (prefs.getString('languageCode') ?? 'en');

    await S.load(Locale(_languageCode));
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
    await prefs.setString('languageCode', _languageCode);
    await prefs.setBool('useSystemTheme', _useSystemTheme);
    await prefs.setBool('useSystemLanguage', _useSystemLanguage);
    await prefs.setBool('saveCredentials', _saveCredentials);
  }

  void toggleTheme(bool isDark) async {
    if (_isDarkTheme != isDark) {
      _isDarkTheme = isDark;
      await _saveToPrefs();
      notifyListeners();
    }
  }

  void toggleUseSystemTheme(bool value) async {
    if (_useSystemTheme != value) {
      _useSystemTheme = value;
      if (value) {
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        _isDarkTheme = brightness == Brightness.dark;
      }
      await _saveToPrefs();
      notifyListeners();
    }
  }

  void toggleUseSystemLanguage(bool value) async {
    if (_useSystemLanguage != value) {
      _useSystemLanguage = value;
      if (value) {
        final locale = WidgetsBinding.instance.platformDispatcher.locale;
        _languageCode = locale.languageCode;
        await S.load(locale);
      }
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    if (_languageCode != locale.languageCode) {
      _languageCode = locale.languageCode;
      await S.load(locale);
      await _saveToPrefs();
      notifyListeners();
    }
  }

  void updateFromSystem() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final locale = WidgetsBinding.instance.platformDispatcher.locale;

    bool shouldUpdate = false;

    if (_useSystemTheme) {
      final systemIsDark = brightness == Brightness.dark;
      if (_isDarkTheme != systemIsDark) {
        _isDarkTheme = systemIsDark;
        shouldUpdate = true;
      }
    }

    if (_useSystemLanguage) {
      if (_languageCode != locale.languageCode) {
        _languageCode = locale.languageCode;
        S.load(locale);
        shouldUpdate = true;
      }
    }

    if (shouldUpdate) {
      _saveToPrefs();
      notifyListeners();
    }
  }

  void toggleSaveCredentials(bool value) async {
    if (_saveCredentials != value) {
      _saveCredentials = value;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('saveCredentials', value);

      notifyListeners();
    }
  }

  void saveUserCredentials(String email, String password) async {
    _savedEmail = email;
    _savedPassword = password;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedEmail', email);
    await prefs.setString('savedPassword', password);

    notifyListeners();
  }

  void clearSavedCredentials() async {
    _savedEmail = null;
    _savedPassword = null;
    await _saveToPrefs();
  }
}
