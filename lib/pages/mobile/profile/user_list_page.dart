import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/pages/mobile/profile/profile.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  final String title;
  final List<String> userIds;

  const UserListPage({Key? key, required this.title, required this.userIds})
      : super(key: key);

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
                return const ListTile(
                  title: Text('Loading...'),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  title: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData) {
                return const ListTile(
                  title: Text('User not found'),
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
                        builder: (context) => Profile(userId: user.uid),
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
