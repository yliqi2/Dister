import 'package:dister/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      String email, String password, BuildContext context) async {
    String error;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Check for known Firebase Auth error codes
      switch (e.code) {
        case "invalid-credential":
          // ignore: use_build_context_synchronously
          error = S.of(context).errorCredential; // User not found
          break;
        case "network-request-failed":
          // ignore: use_build_context_synchronously
          error = S.of(context).errorNetwork; // Network issues
          break;
        default:
          error = S.of(context).errorUnknow(
                e.message.toString(),
              ); // General error message
          break;
      }

      // Elimina cualquier SnackBar ya mostrado
      if (context.mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();

        // Muestra el nuevo SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }

      return null;
    }
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<User?> register(String email, String password) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       // User? user = userCredential.user;

//       //  if (user != null) {
//       //   // Guardar información en Firestore
//       //   await _firestore.collection('users').doc(user.uid).set({
//       //     'nombre': nombre,
//       //     'email': email,
//       //     'uid': user.uid,
//       //   });
//       //   print("Usuario registrado correctamente");
//       //   return user;
//       // }
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'email-already-in-use':
//         default:
//       }
//     }
//   }
// }
