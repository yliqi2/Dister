import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkTheme = false;

  ThemeNotifier() {
    _loadTheme();
  }

  bool get isDarkTheme => _isDarkTheme;

  // Cargar tema de preferencias
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  // Guardar tema en preferencias
  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDark);
  }

  void toggleTheme(bool isDark) async {
    if (_isDarkTheme != isDark) {
      _isDarkTheme = isDark;
      await _saveTheme(isDark);
      notifyListeners();
    }
  }
}
