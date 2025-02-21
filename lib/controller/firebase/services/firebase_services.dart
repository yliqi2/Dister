import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:dister/model/user.dart';

class FirebaseServices {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getCurrentUser() {
    User? user = _auth.currentUser;
    return user?.uid ?? 'error';
  }

  Future<Users?> getCredentialsUser(String uid) async {
    DocumentSnapshot dn = await _fs.collection('users').doc(uid).get();

    if (dn.exists) {
      return Users.fromMap(dn.data() as Map<String, dynamic>);
    }
    return null;
  }
}
