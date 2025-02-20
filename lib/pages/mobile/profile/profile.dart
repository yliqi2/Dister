import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/model/user.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices firebaseServices = FirebaseServices();

    return FutureBuilder<Users?>(
      future: firebaseServices.getCredentialsUser(), // Call the method here
      builder: ( context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No user data available'));
        } else {
          // Successfully retrieved the user data
          Users user = snapshot.data!;
          return Column(
            children: [
              Text('Username: ${user.username}'),
              Text('Followers: ${user.followers}'),
              Text('Listings: ${user.listings}'),
              // Display more user data as needed
            ],
          );
        }
      },
    );
  }
}
