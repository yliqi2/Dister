import 'package:flutter/material.dart';
import 'package:dister/generated/l10n.dart';

class LanguageNotifier extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void changeLanguage(Locale locale) {
    _locale = locale;
    S.load(locale); // Cargar el idioma seleccionado
    notifyListeners(); // Notificar a los widgets dependientes
  }
}
