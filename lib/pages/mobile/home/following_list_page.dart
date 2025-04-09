import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:dister/pages/mobile/chat/chat_screen.dart';

class FollowingListPage extends StatelessWidget {
  const FollowingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices firebaseServices = FirebaseServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firebaseServices.getFollowingUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No following users found.'));
          } else {
            final followingUsers = snapshot.data!;
            return ListView.builder(
              itemCount: followingUsers.length,
              itemBuilder: (context, index) {
                final user = followingUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['photo'].startsWith('http')
                        ? NetworkImage(user['photo'])
                        : AssetImage(user['photo']) as ImageProvider,
                  ),
                  title: Text(user['username']),
                  trailing: IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: () {
                      if (user['uid'] != null && user['username'] != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              recipientId: user['uid'],
                              recipientName: user['username'],
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('User data is incomplete.')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
