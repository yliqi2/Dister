import 'package:flutter/material.dart';
import 'package:dister/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends ChangeNotifier {
  Locale _locale = const Locale('en');

  LanguageNotifier() {
    _loadLanguage();
  }

  Locale get locale => _locale;

  // Cargar idioma de preferencias
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      await S.load(_locale);
    }
    notifyListeners();
  }

  // Guardar idioma en preferencias
  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  void changeLanguage(Locale locale) async {
    if (_locale.languageCode != locale.languageCode) {
      _locale = locale;
      // Esperar a que se cargue el idioma seleccionado antes de notificar a los widgets
      await S.load(locale);
      await _saveLanguage(locale.languageCode);
      notifyListeners(); // Notificar a todos los widgets dependientes
    }
  }
}
