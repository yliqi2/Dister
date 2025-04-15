import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/chat.dart'; // Asegúrate de importar el modelo de Chat
import 'package:dister/generated/l10n.dart'; // Importar para internacionalización

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

    // Limpiar el campo de texto
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

                // Desplazar al final después de que se carguen los mensajes
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (messages.isNotEmpty) {
                    _scrollToBottom();
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  itemCount: messages.length,
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
                              color: isMe ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat.message,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _formatDate(chat.sentDate),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
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
      // Hoy, mostrar solo la hora
      return '${S.of(context).today} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      // Ayer
      return '${S.of(context).yesterday} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      // Otro día, mostrar fecha y hora
      return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
