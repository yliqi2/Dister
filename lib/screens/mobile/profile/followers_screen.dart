import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:dister/screens/mobile/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:dister/generated/l10n.dart';

class FollowersScreen extends StatelessWidget {
  final String title;
  final List<String> userIds;

  const FollowersScreen(
      {super.key, required this.title, required this.userIds});

  @override
  Widget build(BuildContext context) {
    FirebaseServices firebaseServices = FirebaseServices();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: userIds.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: firebaseServices.getCredentialsUser(userIds[index]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text(S.of(context).loading),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  title: Text(
                      S.of(context).errorGeneric(snapshot.error.toString())),
                );
              } else if (!snapshot.hasData) {
                return ListTile(
                  title: Text(S.of(context).userNotFound),
                );
              } else {
                var user = snapshot.data!;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user.photo),
                  ),
                  title: Text(user.username),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: user.uid),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
