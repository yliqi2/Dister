import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingListPage extends StatelessWidget {
  const FollowingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      user['photoUrl'] != null && user['photoUrl'].isNotEmpty
                          ? NetworkImage(user['photoUrl'])
                          : AssetImage("assets/images/default.png")
                              as ImageProvider,
                ),
                title: Text(user['username']),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Placeholder for send message functionality
                  },
                  child: const Text('Send Message'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
