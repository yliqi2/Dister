import 'package:firebase_auth/firebase_auth.dart';

class Logged {
  Future<User?> checkUserLoggedIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user;
  }
}
