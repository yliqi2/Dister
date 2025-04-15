import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String sender; // Quien envía el mensaje
  final String receiver; // Quien recibe el mensaje
  final String message; // El mensaje en sí
  final DateTime sentDate; // Fecha y hora en que se envió el mensaje

  Chat({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.sentDate,
  });

  // Método para convertir la clase a un mapa (útil para JSON)
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'sentDate': Timestamp.fromDate(sentDate),
    };
  }

  // Método para crear una instancia de Chat desde un mapa (útil para JSON)
  factory Chat.fromMap(Map<String, dynamic> map) {
    // Manejo de diferentes tipos de timestamp que pueden venir de Firestore
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) {
        return date.toDate();
      } else if (date is String) {
        return DateTime.parse(date);
      } else {
        return DateTime.now(); // Fallback, no debería ocurrir
      }
    }

    return Chat(
      sender: map['sender'],
      receiver: map['receiver'],
      message: map['message'],
      sentDate: parseDate(map['sentDate']),
    );
  }
}
