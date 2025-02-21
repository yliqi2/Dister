import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dister/controller/provider/authnotifier.dart';

import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> register(
    String email,
    String password,
    String username,
    RegisterErrorNotifier errorNotifier,
  ) async {
    try {
      var userDoc = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (userDoc.docs.isNotEmpty) {
        // Si el nombre de usuario ya está en uso, lanzamos un error
        errorNotifier.error = 'username-already-in-use';
        return null;
      }
      // Si no existe, creamos un nuevo usuario en Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Creamos un objeto `Users` con los datos por defecto
      Users newUser = Users(
        uid: uid,
        username: username,
        photo: 'assets/images/default.png', // Foto vacía inicialmente
        followers: 0, // Inicializamos seguidores en 0
        following: 0, // Inicializamos siguiendo en 0
        listings: 0, // Inicializamos publicaciones en 0
        desc: '',
      );

      // Almacenamos el nuevo usuario en Firestore
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'username': newUser.username,
        'photo': newUser.photo,
        'followers': newUser.followers,
        'folliwing': newUser.following,
        'listings': newUser.listings,
        'desc': newUser.desc,
      });

      return userCredential.user; // Devolvemos el usuario registrado
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          errorNotifier.error = 'email-already-in-use';
          break;
        default:
          errorNotifier.error = 'default';
          break;
      }
      return null; // Si ocurre un error, devolvemos null
    }
  }

  Future<User?> login(
    String email,
    String password,
    LoginAuthErrorNotifier errorNotifier,
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
