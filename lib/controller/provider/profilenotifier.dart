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


//TODO
/*
Al subir un post se guardara con onwer UID
por tanto se podra acceder al perfil por UID
quiero notificar el cambio de UID a la pantalla de profile
asi al notificarlo cambiara toda la ui de profile
*/