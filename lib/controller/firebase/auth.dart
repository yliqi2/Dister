import 'package:dister/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dister/controller/provider/authnotifier.dart';

import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register(
    String email,
    String password,
    AuthErrorNotifier errorNotifier,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'email-already-in-use';
          break;
        default:
          errorMessage = 'default';
          break;
      }
      errorNotifier.error = errorMessage;
      return null;
    }
  }

  Future<User?> login(
    String email,
    String password,
    AuthErrorNotifier errorNotifier,
  ) async {
    String error;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        switch (e.code) {
          case "invalid-credential":
            error = 'invalid-credential';
            break;
          case "network-request-failed":
            error = 'network-request-failed';
            break;
          default:
            error = 'default';
            break;
        }
        errorNotifier.error = error;
      });
      return null;
    }
  }
}
