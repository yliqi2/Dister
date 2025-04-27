import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/model/user.dart';

import 'package:flutter/material.dart';

class Profilenotifier extends ChangeNotifier {
  Users? _selectedUser;
  final FirebaseServices _firebaseServices = FirebaseServices();

  Users? get selectedUser => _selectedUser;

  Future<void> loadUserProfile(String uid) async {
    _selectedUser = await _firebaseServices.getCredentialsUser(uid);
    notifyListeners();
  }
}
