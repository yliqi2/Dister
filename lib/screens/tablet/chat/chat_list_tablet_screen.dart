import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:dister/screens/tablet/chat/chat_tablet_screen.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/widgets/sidebar_tablet.dart';
import 'package:dister/screens/tablet/others/home_tablet_screen.dart';

class ChatListTabletScreen extends StatelessWidget {
  const ChatListTabletScreen({super.key});

  String _generateChatId(String user1, String user2) {
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
      body: Row(
        children: [
          SidebarTablet(
            selectedIndex: 0,
            onTap: (index) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HomeTabletScreen(initialIndex: index),
                ),
                (route) => false,
              );
            },
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        S.of(context).messages,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: firebaseServices.getFollowingUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(S
                                .of(context)
                                .error(snapshot.error.toString())));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text(S.of(context).noFollowingUsersFound));
                      } else {
                        final followingUsers = snapshot.data!;
                        return ListView.builder(
                          itemCount: followingUsers.length,
                          itemBuilder: (context, index) {
                            final user = followingUsers[index];
                            final chatId =
                                _generateChatId(currentUserId, user['uid']);

                            return FutureBuilder<Map<String, dynamic>?>(
                              future: getLastMessage(chatId),
                              builder: (context, messageSnapshot) {
                                if (messageSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    title: Text(S.of(context).loadingChats),
                                  );
                                } else if (messageSnapshot.hasError) {
                                  return ListTile(
                                    title: Text(user['username']),
                                    subtitle:
                                        Text(S.of(context).errorLoadingMessage),
                                  );
                                } else {
                                  final lastMessageData = messageSnapshot.data;
                                  final lastMessage =
                                      lastMessageData?['lastMessage'] ?? '';
                                  final lastMessageDate =
                                      lastMessageData?['lastUpdated'] != null
                                          ? DateFormat('dd/MM/yyyy HH:mm')
                                              .format((lastMessageData![
                                                          'lastUpdated']
                                                      as Timestamp)
                                                  .toDate())
                                          : '';

                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          user['photo'].startsWith('http')
                                              ? NetworkImage(user['photo'])
                                              : AssetImage(user['photo'])
                                                  as ImageProvider,
                                    ),
                                    title: Text(user['username']),
                                    subtitle: lastMessage.isNotEmpty
                                        ? Text(
                                            S.of(context).lastMessage(
                                                lastMessage, lastMessageDate),
                                            style:
                                                const TextStyle(fontSize: 12))
                                        : null,
                                    trailing: IconButton(
                                      icon: const Icon(Icons.send_rounded),
                                      onPressed: () {
                                        if (user['uid'] != null &&
                                            user['username'] != null) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatTabletScreen(
                                                recipientId: user['uid'],
                                                recipientName: user['username'],
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(S
                                                    .of(context)
                                                    .incompleteUserData)),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
