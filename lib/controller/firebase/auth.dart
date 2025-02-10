import 'package:dister/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dister/controller/provider/authnotifier.dart';

import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

  Future<User?> register(
      String email, String password, BuildContext context) async {
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
          errorMessage =
              'El correo electrónico ya está en uso. Intenta con otro.';
          break;
        default:
          errorMessage = 'Ha ocurrido un error desconocido: ${e.message}';
      }

      // Elimina cualquier SnackBar ya mostrado
      if (context.mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();

        // Muestra el nuevo SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }

      return null;
    }
  }

  Future<User?> login(
    String email,
    String password,
    BuildContext context,
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
            error = S.of(context).errorCredential;
            break;
          case "network-request-failed":
            error = S.of(context).errorNetwork;
            break;
          default:
            error = S.of(context).errorUnknow(e.message.toString());
            break;
        }
        errorNotifier.error = error;
      });
      return null;
    }
  }
}
