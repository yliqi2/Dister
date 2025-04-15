import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/chat.dart'; // Asegúrate de importar el modelo de Chat

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
    final chat = Chat(
      sender: currentUserId,
      receiver: widget.recipientId,
      message: message,
      sentDate: DateTime.now(),
    );

    // Crear el documento del chat si no existe y agregar el mensaje a la subcolección "messages"
    final chatDoc = _firestore.collection('chats').doc(chatId);
    await chatDoc.set({
      'users': [currentUserId, widget.recipientId],
      'lastMessage': message,
      'lastUpdated': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    await chatDoc.collection('messages').add(chat.toMap());

    // Limpiar el campo de texto
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recipientName}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('sentDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final chat = Chat.fromMap(data);

                    final isMe = chat.sender == currentUserId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(chat.message),
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
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
