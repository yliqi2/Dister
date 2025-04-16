import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:dister/pages/mobile/chat/chat_screen.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingListPage extends StatelessWidget {
  const FollowingListPage({super.key});

  String _generateChatId(String user1, String user2) {
    // Ordenar los IDs alfabéticamente para que el chatId sea consistente
    final sortedIds = [user1, user2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  Future<Map<String, dynamic>?> getLastMessage(String chatId) async {
    final chatCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1);

    final snapshot = await chatCollection.get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices firebaseServices = FirebaseServices();
    final currentUserId = firebaseServices.getCurrentUser();

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
                final chatId = _generateChatId(currentUserId, user['uid']);

                return FutureBuilder<Map<String, dynamic>?>(
                  future: getLastMessage(chatId),
                  builder: (context, messageSnapshot) {
                    if (messageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const ListTile(
                        title: Text('Cargando...'),
                      );
                    } else if (messageSnapshot.hasError) {
                      return ListTile(
                        title: Text(user['username']),
                        subtitle: const Text('Error al cargar el mensaje.'),
                      );
                    } else {
                      final lastMessageData = messageSnapshot.data;
                      final lastMessage = lastMessageData?['lastMessage'] ?? '';
                      final lastMessageDate =
                          lastMessageData?['lastUpdated'] != null
                              ? DateFormat('dd/MM/yyyy HH:mm').format(
                                  (lastMessageData!['lastUpdated'] as Timestamp)
                                      .toDate())
                              : '';

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user['photo'].startsWith('http')
                              ? NetworkImage(user['photo'])
                              : AssetImage(user['photo']) as ImageProvider,
                        ),
                        title: Text(user['username']),
                        subtitle: lastMessage.isNotEmpty
                            ? Text('$lastMessage\n$lastMessageDate',
                                style: const TextStyle(fontSize: 12))
                            : null, // Mostrar solo si hay mensaje.
                        trailing: IconButton(
                          icon: const Icon(Icons.send_rounded),
                          onPressed: () {
                            if (user['uid'] != null &&
                                user['username'] != null) {
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
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
