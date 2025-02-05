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

      // Si el registro es exitoso, devuelve el usuario
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
    } catch (e) {
      // Error inesperado
      if (context.mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado: $e')),
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
