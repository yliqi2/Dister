import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:dister/models/user_model.dart';

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
