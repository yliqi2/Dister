import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/models/chat_model.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/widgets/sidebar_tablet.dart';
import 'package:intl/intl.dart';
import 'package:dister/screens/tablet/others/home_tablet_screen.dart';

class ChatTabletScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;

  const ChatTabletScreen({
    super.key,
    required this.recipientId,
    required this.recipientName,
  })  : assert(recipientId != ''),
        assert(recipientName != '');

  @override
  State<ChatTabletScreen> createState() => _ChatTabletScreenState();
}

class _ChatTabletScreenState extends State<ChatTabletScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseServices _firebaseServices = FirebaseServices();
  final ScrollController _scrollController = ScrollController();
  String currentUserId = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String chatId = '';

  @override
  void initState() {
    super.initState();
    String uid = _firebaseServices.getCurrentUser();
    setState(() {
      currentUserId = uid;
      chatId = _generateChatId(currentUserId, widget.recipientId);
    });
  }

  String _generateChatId(String user1, String user2) {
    final sortedIds = [user1, user2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    final chat = Chat(
      sender: currentUserId,
      receiver: widget.recipientId,
      message: message,
      sentDate: DateTime.now(),
    );

    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(chat.toMap());

      await _firestore.collection('chats').doc(chatId).set({
        'lastMessage': message,
        'lastUpdated': Timestamp.now(),
      });

      _messageController.clear();
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Row(
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
                          S.of(context).chatWith(widget.recipientName),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('chats')
                          .doc(chatId)
                          .collection('messages')
                          .orderBy('sentDate', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text(S.of(context).noMessages));
                        }

                        final messages = snapshot.data!.docs;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (messages.isNotEmpty) {
                            _scrollToBottom();
                          }
                        });

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final data =
                                messages[index].data() as Map<String, dynamic>;
                            final chat = Chat.fromMap(data);
                            final isMe = chat.sender == currentUserId;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment: isMe
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer
                                              .withAlpha(204)
                                          : Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withAlpha(25),
                                              width: 0.5,
                                            )
                                          : null,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chat.message,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isMe
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          _formatDate(chat.sentDate),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: S.of(context).typeMessage,
                              hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                            ),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
