import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/model/user.dart';
import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/widgets/profiletile.dart';

import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String? userId; // ID del usuario cuyo perfil se desea visualizar

  const Profile({super.key, this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    FirebaseServices firebaseServices = FirebaseServices();

    return FutureBuilder<Users?>(
      future: widget.userId != null
          ? firebaseServices.getCredentialsUser(widget.userId!)
          : firebaseServices
              .getCredentialsUser(firebaseServices.getCurrentUser()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No user data available'));
        } else {
          Users user = snapshot.data!;
          bool isCurrentUser = widget.userId == null ||
              widget.userId == firebaseServices.getCurrentUser();

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading:
                  widget.userId != null, // True if accessed via post
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '@${user.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              centerTitle: true,
              actions: isCurrentUser
                  ? [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: IconButton(
                          onPressed: () async {
                            try {
                              FirebaseServices firebaseServices =
                                  FirebaseServices();
                              await firebaseServices.signOut();
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                  (route) => false,
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error during logout: $e')),
                              );
                            }
                          },
                          icon: const Icon(Icons.logout),
                        ),
                      ),
                    ]
                  : null, // No logout button for other users' profiles
            ),
            body: SafeArea(
              child: UserProfileWidget(
                user: user,
                isCurrentUser: isCurrentUser, // Pass ownership flag
              ),
            ),
          );
        }
      },
    );
  }
}
