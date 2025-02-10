import 'package:flutter/material.dart';

class AuthErrorNotifier extends ChangeNotifier {
  String? _error;

  String? get error => _error;

  set error(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
}
