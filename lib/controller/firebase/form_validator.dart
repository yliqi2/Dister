import 'package:dister/generated/l10n.dart';
import 'package:flutter/material.dart';

class FormValidator {
  // [username] comprobación de formato correcto
  static String? usernameValidator(
    String? value,
    BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return S.of(context).emptyUsername;
    }
    if (value.length < 5) {
      return S.of(context).shortUsername;
    }
    if (value.length > 15) {
      return S.of(context).longUsername;
    }
    if (value.contains(' ')) {
      return S.of(context).containsSpace;
    }
    return null;
  }

  //[email]
  static String? emailValidator(
    String? value,
    BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return S.of(context).emptyEmail;
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(value)) {
      return S.of(context).invalidEmail;
    }
    if (!value.endsWith('@gmail.com')) {
      return S.of(context).notValidDomainEmail;
    }

    return null;
  }

  static String? passwordValidator(
    String? value,
    BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return S.of(context).emptyPassword;
    }
    if (value.length < 8) {
      return S.of(context).lenghtPassword;
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value)) {
      return S.of(context).segurityPassword;
    }
    return null;
  }

  static String? confirmPassValidator(
      String? confirmPass, String pass, BuildContext context) {
    if (confirmPass == null || confirmPass.isEmpty) {
      return S.of(context).emptyConfirmPassword;
    }
    if (confirmPass != pass) {
      return S.of(context).segurityConfirmPassword;
    }
    return null;
  }
}
