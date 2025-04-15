import 'package:flutter/material.dart';

class RegisterErrorNotifier extends ChangeNotifier {
  String? _error;

  String? get error => _error;

  set error(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
}

class LoginAuthErrorNotifier extends ChangeNotifier {
  String? _error;

  String? get error => _error;

  set error(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
}
