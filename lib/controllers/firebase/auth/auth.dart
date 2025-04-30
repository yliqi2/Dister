import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dister/controllers/provider/authnotifier.dart';

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
        errorNotifier.error = 'username-already-in-use';
        return null;
      }
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      Users newUser = Users(
        uid: uid,
        username: username,
        photo: 'assets/images/default.png',
        followers: [],
        following: [],
        listings: 0,
        desc: '',
      );

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'username': newUser.username,
        'photo': newUser.photo,
        'followers': newUser.followers,
        'following': newUser.following,
        'listings': newUser.listings,
        'desc': newUser.desc,
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          errorNotifier.error = 'email-already-in-use';
          break;
        default:
          errorNotifier.error = 'default';
          break;
      }
      return null;
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
