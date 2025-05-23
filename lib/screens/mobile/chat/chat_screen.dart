import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/models/chat_model.dart';
import 'package:dister/generated/l10n.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;

  const ChatScreen({
    super.key,
    required this.recipientId,
    required this.recipientName,
  })  : assert(recipientId != ''),
        assert(recipientName != '');

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
      // Generar un chatId único basado en los IDs de los usuarios
      chatId = _generateChatId(currentUserId, widget.recipientId);
    });
  }

  String _generateChatId(String user1, String user2) {
    // Ordenar los IDs alfabéticamente para que el chatId sea consistente
    final sortedIds = [user1, user2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();

    // Crear el documento del chat si no existe y agregar el mensaje a la subcolección "messages"
    final chatDoc = _firestore.collection('chats').doc(chatId);
    await chatDoc.set({
      'users': [currentUserId, widget.recipientId],
      'lastMessage': message,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Crear mensaje usando serverTimestamp
    await chatDoc.collection('messages').add({
      'sender': currentUserId,
      'receiver': widget.recipientId,
      'message': message,
      'sentDate': FieldValue.serverTimestamp(),
    });

    _messageController.clear();

    // Scroll al final después de enviar el mensaje
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollToBottom();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).chatWith(widget.recipientName)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('sentDate', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                    final data = messages[index].data() as Map<String, dynamic>;

                    // Si el mensaje tiene un timestamp pendiente (null), lo saltamos
                    if (data['sentDate'] == null) {
                      return const SizedBox.shrink();
                    }

                    final chat = Chat.fromMap(data);
                    final isMe = chat.sender == currentUserId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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
                          color: Theme.of(context).colorScheme.tertiary),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
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
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return '${S.of(context).today} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return '${S.of(context).yesterday} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
